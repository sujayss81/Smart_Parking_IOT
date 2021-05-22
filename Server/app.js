//----------------------------IMPORTS--------------------------------//

//npm imports
const createError = require("http-errors");
const express = require("express");
const path = require("path");
const logger = require("morgan");
const cors = require("cors");
const app = express();
const jwt = require("jsonwebtoken");

//debuggers
const server_debug = require("debug")("server");
const db_debug = require("debug")("database");
const hw_debug = require("debug")("hardware");

//custom functions
const connectDb = require("./utility/connectToDatabase");
const { dropGates, raiseGates } = require("./utility/gateControl");
const generatecode = require("./utility/generateCode");
const { encrypt, compareHash } = require("./utility/hashing");
const { signupSchema, loginSchema } = require("./utility/validator");

//models
const Reservation = require("./model/reservation");
const User = require("./model/user");

//middlewares
const auth = require("./middleware/auth");

//-------------------------------INIT functions---------------------------------//

connectDb();
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, "assets")));
const corsOpts = {
  origin: "*",

  methods: ["GET", "POST"],

  allowedHeaders: ["Content-Type", "x-auth-token"],
};
app.use(cors(corsOpts));

//-------------------------------------ROUTES-----------------------------------//
// -------GET-------//

app.get("/test", auth, (req, res) => {
  var obj = [];
  for (let i = 0; i < 6; i++)
    obj.push({
      spot_number: i + 1,
      value: i % 2 == 0 ? true : false,
      reserved: i % 2 == 0 ? true : false,
    });
  return res.send({ status: "ok", message: "Sensor status array", body: obj });
});

app.get("/", (req, res) => {
  res.send({
    api: "Smart-Parking-System",
    version: "1.0.0",
    status: "working",
  });
});

app.get("/me", auth, async (req, res) => {
  const email = req.body.decoded.email;
  try {
    var result = await User.findOne({ email: email }).select([
      "-_id",
      "-password",
      "-__v",
    ]);
  } catch (ex) {
    db_debug(result);
  }
  res.send({ status: "ok", message: "User Profile", body: result });
});

app.get("/sensorStatus", auth, async (req, res) => {
  var sensor_status;
  var tcp_con = global.tcpCon;
  var obj = [];
  try {
    await new Promise((resolve, reject) => {
      tcp_con.write("1");
      tcp_con.on("data", async (d) => {
        sensor_status = d.split(",");
        let sum = 0;
        for (var i = 0; i < sensor_status.length; i++) {
          sum += parseInt(sensor_status[i]);
          if (sum == 0) {
            reject();
          } else {
            for (var i = 0; i < sensor_status.length; i++) {
              if (sensor_status[i] > 15 || sensor_status[i] == 0)
                sensor_status[i] = false;
              else sensor_status[i] = true;
              var result = await Reservation.findOne({
                spot_number: i + 1,
              }).catch((e) => {
                db_debug(e);
              });
              var status = result.status == "reserved" ? true : false;
              obj.push({
                spot_number: i + 1,
                value: sensor_status[i],
                reserved: status,
              });
            }
            resolve();
          }
        }
      });
    });
  } catch (e) {
    hw_debug(`ESP failed to return sensor status ${e}`);
    return res.status(500).send({
      status: "failed",
      message: "No Data from hardware",
      error: "Sensors not responding",
    });
  }
  return res.send({ status: "ok", message: "Sensor status array", body: obj });
});

app.get("/reserve", auth, async (req, res) => {
  var { spot } = req.query;
  if (spot == null) {
    return res.status(400).send({
      status: "failed",
      message: "spot parameter required",
    });
  }
  var reserve_doc = await Reservation.findOne({ spot_number: spot }).catch(
    (ex) => db_debug(ex)
  );
  if (reserve_doc.code != null) {
    return res.send({
      status: "reserved",
      message: "Spot already reserved",
    });
  }

  var opr_res = await dropGates(spot);
  if (opr_res) {
    var code = generatecode();
    await Reservation.updateOne(
      { spot_number: spot },
      { $set: { status: "reserved", code: code } }
    ).catch((e) => db_debug(e));

    var millis = process.env.RESERVATION_EXPIRY * 60000;

    res.send({ status: "ok", message: "Spot Reserved", code: code });

    setTimeout(async () => {
      await Reservation.updateOne(
        { spot_number: spot },
        { $set: { status: "not-reserved", code: null } }
      ).catch((e) => db_debug(e));
      if (await raiseGates(spot)) {
        server_debug("Reservation invoked due to timeout");
      }
    }, millis);
  }
});

app.get("/release", auth, async (req, res) => {
  var { spot, code } = req.query;
  if (spot == null) {
    return res.status(400).send({
      status: "failed",
      message: "spot parameter required",
    });
  } else if (code == null) {
    return res.status(400).send({
      status: "failed",
      message: "code parameter required",
    });
  }
  var result = await Reservation.findOne({ spot_number: spot }).catch((e) =>
    db_debug(e)
  );
  if (code == result.code) {
    if (await raiseGates(spot)) {
      await Reservation.updateOne(
        { spot_number: spot },
        {
          $set: {
            status: "not-reserved",
            code: null,
          },
        }
      ).catch((e) => db_debug(e));
    }
  } else {
    return res.status(400).send({
      status: "failed",
      message: "invalid code",
    });
  }
  return res.send({
    status: "ok",
    message: "spot Released",
  });
});

// --------POST--------//

app.post("/login", async (req, res) => {
  const val_res = loginSchema.validate(req.body);
  if (val_res.error == null) {
    var { email, password } = req.body;
    try {
      var result = await User.find({
        email: email,
      });
    } catch {
      (ex) => {
        db_debug(ex);
      };
    }
    if (result.length > 0) {
      if (await compareHash(password, result[0].password)) {
        var token = jwt.sign({ email: email }, process.env.JWT_SECRET);
        return res.header({ "x-auth-token": token }).send({
          status: "ok",
          message: "Authentication successfull",
        });
      }
    }
  } else {
    server_debug("Missing params");
    return res.status(400).send({
      status: "failed",
      message: "Missing/Incorrect Parameters",
      body: val_res.error.details,
    });
  }
  server_debug("Incorrect email/pass");
  return res.status(400).send({
    status: "failed",
    message: "Incorrect Email/Password",
  });
});

app.post("/signup", async (req, res) => {
  var val_res = await signupSchema.validate(req.body);
  if (val_res.error == null) {
    var { name, email, password, dob, gender } = req.body;
    password = await encrypt(password);
    email = email.toLowerCase();
    var user = new User({ name, email, password, dob, gender });
    await user
      .save()
      .then(() => {
        var token = jwt.sign({ email: email }, process.env.JWT_SECRET);
        return res.header({ "x-auth-token": token }).send({
          status: "ok",
          message: "registration successfull",
        });
      })
      .catch((ex) => {
        db_debug(ex);
        if (ex.dupData != null && ex.dupData == 1) {
          server_debug("Email already registered");
          return res.status(409).send({
            status: "failed",
            message: "email already registered",
          });
        }
      });
  } else {
    server_debug("Missing params");
    return res.status(400).send({
      status: "failed",
      message: "Missing/Incorrect Parameters",
      body: val_res.error.details,
    });
  }
});

//----------Error-Handlers--------------//

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  server_debug(err);
  res.status(err.status || 500);
  res.send({ status: "failed", message: "500 Sever Error" });
});

module.exports = app;
