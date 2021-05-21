const mongoose = require("mongoose");

const userSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      lowercase: true,
      required: true,
      unique: true,
    },
    password: {
      type: String,
      required: true,
    },
    dob: {
      type: String,
      required: true,
    },
    gender: {
      type: String,
      required: true,
    },
  },
  { emitIndexErrors: true }
);

var handleE11000 = function (error, res, next) {
  if (error.name === "MongoError" && error.code === 11000) {
    next({ dupData: 1 });
  } else {
    next();
  }
};

userSchema.post("save", handleE11000);
userSchema.post("update", handleE11000);

module.exports = mongoose.model("users", userSchema);
