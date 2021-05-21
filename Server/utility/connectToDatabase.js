const mongoose = require("mongoose");
const db_debug = require("debug")("database");

mongoose.set("useUnifiedTopology", true);
mongoose.set("useNewUrlParser", true);
mongoose.set("useFindAndModify", false);
mongoose.set("useCreateIndex", true);
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
