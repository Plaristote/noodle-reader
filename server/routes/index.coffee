express   = require 'express'
fs        = require 'fs'
router    = express.Router()
indexHtml = null

fs.readFile __dirname + '/public/index.html', 'utf8', (err, text) ->
  indexHtml = text

router.get '/', (req, res, next) ->
  res.send indexHtml

module.exports = router
