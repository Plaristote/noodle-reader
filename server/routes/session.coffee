require '../models/models'
passport         = require 'passport'
LocalStrategy    = (require 'passport-local').Strategy
express          = require 'express'
router           = express.Router()

auth_fail_message = 'Incorrect username or password'

passport.use new LocalStrategy { usernameField: 'email' }, (email, password, done) ->
  console.log "searching for user #{email}"
  User.findOne { email: email }, (err, user) ->
    console.log "searched over"
    if err
      done err
    else if !user
      done null, false, message: auth_fail_message
    else
      user.comparePasswords password,
        success: -> done null, user
        failure: -> done null, false, message: auth_fail_message

# Require authentication
router.all '/api/*', (req, res) ->
  return if req.path == '/api/users/new'
  authorize = passport.authorize 'local', (err, user, data) ->
    res.json data if err or user == false
  authorize req, res

router.post '/session', (req, res) ->
  passport.authenticate 'local', (err, user, data) ->
    if err or !user
      res.json req.data
    else
      res.json user

module.exports = router
