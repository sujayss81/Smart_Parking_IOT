const hw_debug = require("debug")("hardware");

const dropGates = async (spot) => {
  var res = await new Promise((resolve, reject) => {
    try {
      global.tcpCon.write(`2${spot}`);
      global.tcpCon.on("data", async (d) => {
        resolve(d);
      });
    } catch (e) {
      reject(e);
    }
  }).catch((e) => hw_debug(e));
  if (res == "ok") {
    return 1;
  } else {
    return 0;
  }
};

const raiseGates = async (spot) => {
  var res = await new Promise((resolve, reject) => {
    try {
      global.tcpCon.write(`3${spot}`);
      global.tcpCon.on("data", async (d) => {
        resolve(d);
      });
    } catch (e) {
      reject(e);
    }
  }).catch((e) => hw_debug(e));
  if (res == "ok") {
    return 1;
  } else {
    return 0;
  }
};

module.exports = { dropGates, raiseGates };
