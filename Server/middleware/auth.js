const jwt = require("jsonwebtoken");
const auth_debug = require("debug")("auth");

module.exports = (req, res, next) => {
  var token = req.headers["x-auth-token"];

  if (token == null) {
    auth_debug("Failed line 8");
    return res.status(400).send({
      status: "failed",
      message: "Authentication failed",
    });
  }
  try {
    req.body.decoded = jwt.verify(token, process.env.JWT_SECRET);
    // if (req.body.decoded == null) {
    //   console.log("Auth Failed");
    //   return res.status(400).send({
    //     status: "failed",
    //     message: "Authentication failed",
    //   });
    // } else
    next();
  } catch (e) {
    console.log(e);
    auth_debug(`Failed line 25 \n${e}`);
    return res.status(400).send({
      status: "failed",
      message: "Authentication failed",
    });
  }
};
