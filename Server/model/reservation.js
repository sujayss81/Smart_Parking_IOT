const mongoose = require("mongoose");

const reservationSchema = mongoose.Schema({
  spot_number: {
    type: Number,
    required: true,
  },
  status: {
    type: String,
    required: true,
  },
  code: {
    type: Number,
  },
});

module.exports = mongoose.model("reservations", reservationSchema);
