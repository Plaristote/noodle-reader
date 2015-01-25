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
      feed.fetchPosts {}, (err) ->
        if err?
          res.status(500).json error: err
        else
          res.json feed: feed.publicAttributes()

router.post '/', (req, res) ->
  url = req.query.url or req.params.url or req.body.url
  console.log 'create feed', url
  req.user.subscribeToFeed url, (err, feed) ->
    if err
      res.status(422).json error: err
    else
      feed.fetchPosts (err) ->
        console.log 'bite', err
        res.json feed: feed.publicAttributes()
        
router.delete '/:id', (req, res) ->
  id = req.params.id
  req.user.unsubscibeFromFeed req.params.id, (err, feed) ->
    if err?
      res.status(500).json error: err
    else if not feed?
      res.status(404).json error: 'not found'
    else
      res.status(200).json success: true

module.exports = router
