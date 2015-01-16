require '../models/models'
express          = require 'express'
router           = express.Router()

# Require authentication
router.get '/', (req, res, next) ->
  console.log 'index'
  res.json coucou: 'index'

router.get '/:id', (req, res, next) ->
  console.log 'get'
  res.json coucou: 'get'

router.put '/:id', (req, res, next) ->
  console.log 'update'
  res.json coucou: 'update'
  
router.post '/new', (req, res) ->
  console.log 'create'

module.exports = router
