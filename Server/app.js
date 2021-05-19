var createError = require("http-errors");
var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
var cors = require("cors");
var app = express();
require("dotenv").config();

// view engine setup

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

app.get("/test", (req, res) => {
  var obj = {};
  for (let i = 0; i < 6; i++)
    obj[i] = { sensor_id: i + 1, value: i % 2 == 0 ? true : false };
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
              obj[i] = { sensor_id: i + 1, value: sensor_status[i] };
            }
            resolve();
          }
        }
      });
    });
  } catch (e) {
    res.send({ error: "Sensors not responding" });
  }
  res.send(obj);
});

app.get("/reserve/:spot", async (req, res) => {
  spot = req.params.spot;
  try {
    await new Promise((resolve, reject) => {
      tcp_con.write(`2${spot}`);
      tcp_con.on("data", async (d) => {
        console.log(d);
        res.send("reserved");
      });
      tcp_con.on("error", (e) => {
        reject(e);
      });
    });
  } catch (e) {
    res.send({ error: "Hardware Error!" });
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
