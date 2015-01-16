express   = require 'express'
router    = express.Router()

# Format JSON
router.all '/*', (req, res, next) ->
  console.log 'set json content type'
  res.header 'Content-Type', 'application/json'
  next()

module.exports = router
