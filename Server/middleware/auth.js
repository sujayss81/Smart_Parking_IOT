const jwt = require("jsonwebtoken");

module.exports = (req, res, next) => {
  var token = req.headers["x-auth-token"];

  if (token == null) {
    return res.status(400).send({
      status: "failed",
      message: "Authentication failed",
    });
  }
  try {
    req.body.decoded = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch (e) {
    return res.status(400).send({
      status: "failed",
      message: "Authentication failed",
    });
  }
};
