express   = require 'express'
router    = express.Router()

# Format JSON
router.all '/*', ->
  res.header 'Content-Type', 'application/json'

module.exports = router
