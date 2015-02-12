mongoose   = require 'mongoose'
request    = require 'request'
FeedParser = require 'feedparser'

require './feed_post'

update_interval = 60 * 2 # 2 minute

build_module = ->
  feed_schema = new mongoose.Schema
    title:       { type: String }
    url:         { type: String, index: { unique: true } }
    link:        { type: String }
    description: { type: String }
    favicon:     { type: String }
    updated_at:  { type: Date   }

  global.Feed = mongoose.model 'Feed', feed_schema

  Feed.garbageCollectFeed = (id, next) ->
    (User.find { feeds: id }).exec (err, users, p3) ->
      return next err if err?
      if users.length == 0
        Feed.findOneAndRemove { id: id }, (err) ->
          next err
      next null

  Feed::shouldUpdate = () ->
    return true
    if @updated_at?
      now         = new Date().getTime()  / 1000
      last_update = @updated_at.getTime() / 1000
      (now - last_update) > update_interval
    else
      true

  Feed::updatePostsIfNeeded = (next) ->
    @updatePosts next if @shouldUpdate()

  Feed::updatePosts = (next) ->
    @initializeFeedParser()
    @feed_parser.on 'error', (error) ->
      next error
    feed         = @
    req          = request @url
    req.on 'error', (err) ->
      next err
    req.on 'response', (res) ->
      feed.onFeedReceived res, @, next
    @updated_at = new Date()
    @save()

  Feed::initializeFeedParser = ->
    feed         = @
    @feed_parser = new FeedParser
    @feed_parser.on 'meta', ->
      feed.updateMetaFromStream @
    @feed_parser.on 'readable', ->
      feed.addFeedItemsFromStream @

  Feed::updateMetaFromStream = (stream) ->
    for field in [ 'title', 'description', 'favicon', 'link' ]
      @[field] = stream.meta[field]
    @save()

  Feed::addFeedItemsFromStream = (stream) ->
    @addFeedItem item while (item = stream.read())

  Feed::addFeedItem = (item) ->
    feed_item = FeedPost.findOrCreate @, item, (err, feedPost) ->
      if err?
        console.log 'failed to create feeditem', err
      else
        feedPost.save (err) ->
          if err?
            console.log 'failed to save feeditem', err
#          else
#            console.log 'added feedPost', feedPost.title, feedPost.feed_id, feedPost

  Feed::onFeedReceived = (res, stream, next) ->
    if res.statusCode != 200
      next "Feed answered with status #{res.statusCode}"
    else
      stream.pipe @feed_parser

  Feed::fetchPosts = (filters, options, next) ->
    feed = @
    filters.feed_id = @id
    criteria = FeedPost.find filters
    criteria = criteria.skip  options.skip
    criteria = criteria.limit options.limit
    criteria = criteria.sort '-publication_date'
    criteria.find (err, results) ->
      if err?
        next err
      else
        console.log 'fetched posts', results
        feed.feedPosts = results
        next null

  Feed::publicAttributes = (include_methods = []) ->
    obj =
      _id:         @id
      title:       @title
      url:         @url
      link:        @link
      description: @description
      favicon:     @favicon
      updated_at:  @updated_at
      feedPosts:   @feedPosts
    obj[key] = @[key]() for key in include_methods
    obj

build_module() unless global.Feed?
