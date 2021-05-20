const hw_debug = require("debug")("hardware");

const dropGates = async (spot) => {
  await new Promise((resolve, reject) => {
    global.tcpCon.write(`2${spot}`);
    global.tcpCon.on("data", async (d) => {
      resolve(d);
    });
  })
    .then((d) => {
      console.log(d);
      if (d == "ok") return 1;
      else return 0;
    })
    .catch((e) => {
      hw_debug("Device not connected");
    });
};

module.exports = { dropGates };
