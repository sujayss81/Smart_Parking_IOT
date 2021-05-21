const Joi = require("joi");

const signupSchema = Joi.object({
  name: Joi.string().required().alphanum().min(3).max(20),
  email: Joi.string().required().email().lowercase(),
  password: Joi.string().min(8).required(),
  dob: Joi.string().required(),
  gender: Joi.string().required(),
});

const loginSchema = Joi.object({
  email: Joi.string().required().email().lowercase(),
  password: Joi.string().required(),
});

module.exports = { signupSchema, loginSchema };
