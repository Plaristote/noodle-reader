require '../models/models'
express          = require 'express'
router           = express.Router()

router.get '/:id', (req, res, next) ->
  Feed.findOne { _id: req.params.id }, (err, feed) ->
    if err?
      res.status(500).json error: err
    else if not feed?
      res.status(404).json error: "feed id #{req.params.id} not found"
    else
      res.json feed: feed.publicAttributes ['posts']

router.post '/', (req, res) ->
  console.log 'create feed', req.query, req.params, req.body
  req.user.subscribeToFeed req.body.url, (err, feed) ->
    if err
      res.status(422).json error: err
    else
      res.json feed: feed.publicAttributes()

module.exports = router
