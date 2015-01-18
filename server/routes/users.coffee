require '../models/models'
express          = require 'express'
router           = express.Router()

# Require authentication
router.get '/', (req, res, next) ->
  console.log 'index', req.user
  res.json coucou: 'index'

router.get '/:id', (req, res, next) ->
  console.log 'get'
  res.json coucou: 'get'

router.put '/:id', (req, res, next) ->
  console.log 'update'
  res.json coucou: 'update'
  
router.post '/', (req, res) ->
  console.log 'create', req.query, req.params, req.body
  user = new User req.body.user
  user.save (err) ->
    if err
      res.status(422).json error: err
    else
      res.json user.publicAttributes()

module.exports = router
