const createError = require("http-errors");
const express = require("express");
const path = require("path");
const cookieParser = require("cookie-parser");
const logger = require("morgan");
const cors = require("cors");
const app = express();
const server_debug = require("debug")("server");
const db_debug = require("debug")("database");
const hw_debug = require("debug")("hardware");
const connectDb = require("./utility/connectToDatabase");
const { dropGates } = require("./utility/gateControl");
const Reservation = require("./model/reservation");
const generatecode = require("./utility/generateCode");

connectDb();
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));
const corsOpts = {
  origin: "*",

  methods: ["GET", "POST"],

  allowedHeaders: ["Content-Type"],
};
app.use(cors(corsOpts));

app.get("/", (req, res) => {
  res.send({
    api: "Smart-Parking-System",
    version: "1.0.0",
    status: "working",
  });
});

app.get("/test", (req, res) => {
  var obj = [];
  for (let i = 0; i < 6; i++)
    obj.push({
      spot_number: i + 1,
      value: i % 2 == 0 ? true : false,
      reserved: i % 2 == 0 ? true : false,
    });
  server_debug(obj[0]);
  res.send(obj);
});

app.get("/sensorStatus", async (req, res) => {
  var sensor_status;
  var obj = {};
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
              obj[i] = { spot_number: i + 1, value: sensor_status[i] };
            }
            resolve();
          }
        }
      });
    });
  } catch (e) {
    res.send({ error: "Sensors not responding" });
    hw_debug("ESP failed to return sensor status");
  }
  res.send(obj);
});

app.get("/reserve", async (req, res) => {
  spot = req.query.spot;
  time = req.query.time;
  var reserve_doc = await Reservation.find({ spot_number: spot });
  server_debug(reserve_doc);
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
    );

    //timeout to release reservation
    res.send({ status: "ok", message: "Spot Reserved", code: code });
  }
});

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
  res.status(err.status || 500);
  res.send();
});

module.exports = app;
