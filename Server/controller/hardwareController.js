//model imports
const Reservation = require("../model/reservation");
const Order = require("../model/order");

//debuggers
const db_debug = require("debug")("database");
const hw_debug = require("debug")("hardware");
const server_debug = require("debug")("server");

//custom functions
const { dropGates, raiseGates } = require("../utility/gateControl");
const generatecode = require("../utility/generateCode");

// ----------------------------------------------------------------//
const sensorStatus = async (req, res) => {
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
};

const reserve = async (req, res) => {
  var email = req.body.decoded.email;
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
    var order = new Order({
      email: email,
      spot_number: spot,
      code: code,
    });
    await order.save().catch((ex) => db_debug(ex));
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
};

const release = async (req, res) => {
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
      return res.send({
        status: "ok",
        message: "spot Released",
      });
    }
  } else {
    return res.status(400).send({
      status: "failed",
      message: "invalid code",
    });
  }
};

module.exports = { sensorStatus, reserve, release };
