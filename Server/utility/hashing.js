const bcrypt = require("bcrypt");
const server_debug = require("debug")("server");

const encrypt = async (pass) => {
  try {
    var salt = await bcrypt.genSalt(8);
    var hash = await bcrypt.hash(pass, salt);
    return hash;
  } catch (ex) {
    server_debug(ex);
  }
};

const compareHash = async (pass, hash) => {
  const res = await bcrypt.compare(pass, hash);
  server_debug(res);
  if (res) {
    return true;
  }
  return false;
};

module.exports = { encrypt, compareHash };
