const mongoose = require("mongoose");

const orderSchema = mongoose.Schema(
  {
    email: {
      type: String,
      lowercase: true,
      required: true,
      ref: "users",
    },
    spot_number: {
      type: Number,
      required: true,
    },
    code: {
      type: Number,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("orders", orderSchema);
