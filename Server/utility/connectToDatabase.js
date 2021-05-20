const mongoose = require("mongoose");
const db_debug = require("debug")("database");

module.exports = () => {
  mongoose
    .connect(process.env.MONGO_URL)
    .then(() => {
      db_debug("Database Connected");
    })
    .catch((e) => {
      db_debug(`Database Connection Failed\n${e}`);
    });
};
