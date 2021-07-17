//----------------------------IMPORTS--------------------------------//

//npm imports
const createError = require("http-errors");
const express = require("express");
const path = require("path");
const logger = require("morgan");
const cors = require("cors");
const app = express();

//debuggers
const server_debug = require("debug")("server");

//custom functions
const connectDb = require("./utility/connectToDatabase");

//Controllers
const { me, login, signup, myOrders } = require("./controller/userController");
const {
  sensorStatus,
  reserve,
  release,
} = require("./controller/hardwareController");

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

//Routers
const { admin } = require("./router/admin");
app.use("/admin", admin);

//-------------------------------------ROUTES-----------------------------------//
// -------GET-------//

app.get("/", (req, res) => {
  res.send({
    api: process.env.APP_NAME,
    version: process.env.APP_VER,
    status: "working",
  });
});

app.get("/test", auth, (req, res) => {
  var obj = [];
  for (let i = 0; i < 5; i++)
    obj.push({
      spot_number: i + 1,
      value: i % 2 == 0 ? true : false,
      reserved: i % 3 == 0 ? true : false,
    });
  return res.send({ status: "ok", message: "Sensor status array", body: obj });
});

app.get("/me", auth, me);

app.get("/myorders", auth, myOrders);

app.get("/sensorStatus", auth, sensorStatus);

app.get("/reserve", auth, reserve);

app.get("/release", auth, release);

// --------POST--------//

app.post("/login", login);

app.post("/signup", signup);

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
