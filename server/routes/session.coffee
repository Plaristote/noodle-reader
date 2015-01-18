require '../models/models'
passport         = require 'passport'
LocalStrategy    = (require 'passport-local').Strategy
express          = require 'express'
router           = express.Router()

authenticate_user_from_credentials = (email, password, done) ->
  User.findOne { email: email }, (err, user) ->
    if err
      done err
    else if !user
      done null, false
    else
      user.comparePasswords password,
        success: -> done null, user
        failure: -> done null, false

authenticate_user_from_id = (id, done) ->
  User.findOne { _id: id }, (err, user) ->
    if err
      done err
    else if !user
      done null, false
    else
      done null, user

passport.use new LocalStrategy { usernameField: 'email' }, authenticate_user_from_credentials

# Require authentication
router.all '/api/*', (req, res, next) ->
  return next() if req.path == '/api/users' and req.method == 'POST'
  authenticate_user_from_id req.signedCookies.user_id, (err, user) ->
    if err or user == false
      res.status(401).json error: 'authentication required'
    else
      req.user = user
      next()

# Create session
router.post '/session', (req, res) ->
  authenticate = passport.authenticate 'local', (err, user, data) ->
    if err
      res.json error: err
    else if !user
      res.json error: 'invalid credentials'
    else
      res.cookie 'user_id', user.id, signed: true
      res.json user
  authenticate req, res

router.delete '/session', (req, res) ->
  if req.signedCookies.user_id?
    res.cookie 'user_id', null, signed: true
    res.json success: true
  else
    res.json error: 'you are not logged in'

module.exports = router
