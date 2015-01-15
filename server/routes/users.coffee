express  = require 'express'
mongoose = require 'mongoose' 
router   = express.Router()

# Require authentication
router.all '/api/users/*', ->
  console.log 'require authentication'

module.exports = router

