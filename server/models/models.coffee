mongoose = require 'mongoose'
bcrypt   = require 'bcrypt'

SALT_WORK_FACTOR = 10

mongoose.connect 'mongodb://localhost/test'

build_module = ->
  user_schema = new mongoose.Schema
    email:    { type: String, required: true, index: { unique: true } }
    password: { type: String, required: true }

  user_schema.pre 'save', (next) ->
    if @isModified 'password'
      @encryptPassword next
    else
      next()

  global.User = mongoose.model 'User', user_schema

  User::encryptPassword = (next) ->
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) =>
      unless err
        bcrypt.hash @password, salt, (err, hash) =>
          @password = hash
          next()
      else
        next()

  User::comparePasswords = (candidate, options) ->
    bcrypt.compare candidate, @password, (err, isMatch) =>
      if isMatch
        options.success()
      else
        options.failure()

build_module() unless global.User?
