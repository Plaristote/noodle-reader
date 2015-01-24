require '../models/models'
express          = require 'express'
router           = express.Router()

# Require authentication
router.get '/', (req, res, next) ->
  res.json req.user.publicAttributes()

router.get '/:id', (req, res, next) ->
  User.findOne { _id: req.params.id }, (err, user) ->
    if err
      res.error(500).json error: err
    else if !user
      res.error(404).json error: 'user does not exist'
    else
      res.json user.publicAttributes()

router.put '/:id', (req, res, next) ->
  if req.params.id != req.user.id
    res.status(401).json error: 'operation not permitted'
  else
    req.user.updateAttributes req.body.user
    req.user.save (err) ->
      if err
        res.status(422).json error: err
      else
        res.json req.user.publicAttributes()

router.post '/', (req, res) ->
  console.log 'create', req.query, req.params, req.body
  user = new User req.body.user
  user.save (err) ->
    if err
      res.status(422).json error: err
    else
      res.json user.publicAttributes()

module.exports = router
