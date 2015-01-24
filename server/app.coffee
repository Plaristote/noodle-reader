express      = require 'express'
path         = require 'path'
favicon      = require 'serve-favicon'
logger       = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser   = require 'body-parser'
passport     = require 'passport'

index   = require './routes/index'
api     = require './routes/api'
users   = require './routes/users'
session = require './routes/session'
feeds   = require './routes/feeds'

app = express()

# view engine setup
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'))
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: true
app.use cookieParser 'SECRET_S141U539C26K12A456D1CK'
app.use passport.initialize()
app.use passport.session()
app.use express.static(path.join(__dirname, 'public'))

app.get '/',            index
app.use '/',            session
app.use '/api',         api
app.use '/api/users',   users
app.use '/api/feeds',   feeds

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next(err)

# error handlers

# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    res.status(err.status || 500)
    res.json
      message: err.message
      error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status(err.status || 500)
  res.json
    message: err.message
    error: {}

module.exports = app
