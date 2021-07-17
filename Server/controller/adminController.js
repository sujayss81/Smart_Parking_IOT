const db_debug = require("debug")("database");
const jwt = require("jsonwebtoken");
const { encrypt, compareHash } = require("../utility/hashing");

const Admin = require("../model/admin");

const login = async (req, res) => {
  const { name, password } = req.body;
  if (name == null || password == null) {
    return res.status(400).send({
      status: "failed",
      message: "Name and password required",
    });
  }
  var result = await Admin.findOne({ name: name });
  if (result != null) {
    if (await compareHash(password, result.password)) {
      var token = jwt.sign({ name: name }, process.env.JWT_SECRET);
      return res.send({
        status: "success",
        message: "Authentication successfull",
        token: token,
      });
    }
  }
  return res.status(400).send({
    status: "failed",
    message: "Username/Password incorrect",
  });
};

const createadmin = async (req, res) => {
  const { name, password } = req.query;
  if (name == null || password == null) {
    return res.status(400).send({
      status: "failed",
      message: "Name and password params required",
    });
  }
  let enc_pass = await encrypt(password);
  let admin = new Admin({
    name: name,
    password: enc_pass,
  });
  await admin.save().catch((e) => db_debug(e));
  res.send({
    status: "ok",
    message: "Admin created",
  });
};

module.exports = { login, createadmin };
