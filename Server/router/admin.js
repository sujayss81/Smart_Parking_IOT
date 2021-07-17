const express = require("express");
const admin = express.Router();
const { login, createadmin } = require("../controller/adminController");

admin.get("/createadmin", createadmin);

admin.post("/login", login);

module.exports = { admin };
