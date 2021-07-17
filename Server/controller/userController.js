//npm imports
const jwt = require("jsonwebtoken");
//debuggers
const server_debug = require("debug")("server");
const db_debug = require("debug")("database");
//model imports
const User = require("../model/user");
const Order = require("../model/order");
//custom functions
const { encrypt, compareHash } = require("../utility/hashing");
const { signupSchema, loginSchema } = require("../utility/validator");

// ------------------------------------------------------------------- //

const me = async (req, res) => {
  const email = req.body.decoded.email;
  try {
    var result = await User.findOne({ email: email }).select([
      "-_id",
      "-password",
      "-__v",
    ]);
  } catch (ex) {
    db_debug(result);
    return res.send({ status: "failed", message: "User Profile not found" });
  }
  res.send({ status: "ok", message: "User Profile", body: result });
};

const myOrders = async (req, res) => {
  var { email } = req.body.decoded;
  var result = await Order.find({ email: email })
    .sort({ createdAt: -1 })
    .select(["-_id", "-__v", "-email"])
    .catch((ex) => db_debug(ex));
  res.send({
    status: "ok",
    message: "User Order list",
    body: result,
    count: result.length,
  });
};

const login = async (req, res) => {
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
};

const signup = async (req, res) => {
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
};

module.exports = { me, myOrders, login, signup };
