express   = require 'express'
router    = express.Router()

# Format JSON
router.all '/*', (req, res, next) ->
  res.header 'Content-Type', 'application/json'
  next()

module.exports = router
