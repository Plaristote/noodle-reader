require '../models/models'
express          = require 'express'
router           = express.Router()

router.get '/', (req, res, next) ->
  console.log "Feeds for user:", req.user.feeds
  
  Feed.find { '_id': { $in: req.user.feeds } }, (err, feeds) ->
    console.log "Found feeds for user:", feeds
    if err?
      res.status(500).json error: err
    else
      res.json feeds

router.get '/:id', (req, res, next) ->
  Feed.findOne { _id: req.params.id }, (err, feed) ->
    if err?
      res.status(500).json error: err
    else if not feed?
      res.status(404).json error: "feed id #{req.params.id} not found"
    else
      render_posts feed, req, res
      feed.updatePostsIfNeeded (err) ->
        console.log 'updated feed', err

render_posts = (feed, req, res) ->
  options            = { limit: 10, skip: 0 }
  filters            = {}
  options.limit      = (parseInt req.query.itemsPerPage) % 100    if req.query.itemsPerPage?
  options.skip       = (parseInt req.query.page) * options.limit  if req.query.page?
  filters.created_at = { $lt: new Date(parseInt req.query.from) } if req.query.from?
  feed.fetchPosts filters, options, (err) ->
    if err?
      res.status(500).json error: err
    else
      res.json feed.publicAttributes()

router.post '/', (req, res) ->
  url = req.query.url or req.params.url or req.body.url
  console.log 'create feed', url
  req.user.subscribeToFeed url, (err, feed) ->
    if err
      res.status(422).json error: err
    else
      feed.fetchPosts {}, { limit: 10, skip: 0 }, (err) ->
        res.json feed.publicAttributes()

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
