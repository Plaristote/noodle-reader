mongoose   = require 'mongoose'
request    = require 'request'
FeedParser = require 'feedparser'

build_module = ->
  feed_schema = new mongoose.Schema
    title:       { type: String }
    url:         { type: String, index: { unique: true } }
    link:        { type: String }
    description: { type: String }
    favicon:     { type: String }
    updated_at:  { type: Date   }

  global.Feed = mongoose.model 'Feed', feed_schema
  
  feed_post_schema = new mongoose.Schema
    feed_id:          { type: mongoose.Schema.Types.ObjectId }
    title:            { type: String }
    category:         { type: String }
    link:             { type: String }
    summary:          { type: String }
    description:      { type: String }
    publication_date: { type: Date   }
    source:           { type: String }
    created_at:       { type: Date   }

  global.FeedPost = mongoose.model 'FeedPost', feed_post_schema

  Feed.garbageCollectFeed = (id, next) ->
    (User.find { feeds: id }).exec (err, users, p3) ->
      return next err if err?
      if users.length == 0
        Feed.findOneAndRemove { id: id }, (err) ->
          next err
      next null

  Feed::updatePosts = (next) ->
    console.log 'feed', @
    @initializeFeedParser()
    @feed_parser.on 'error', (error) ->
      next error
    @feed_parser.on 'readable', ->
      next()
    feed         = @
    req          = request @url
    req.on 'error', (err) ->
      next err
    req.on 'response', (res) ->
      feed.onFeedReceived res, @, next

  Feed::initializeFeedParser = ->
    feed         = @
    @feed_parser = new FeedParser
    @feed_parser.on 'readable', ->
      feed.addFeedItemsFromStream @

  Feed::addFeedItemsFromStream = (stream) ->
    @addFeedItem item while (item = stream.read())
    
  Feed::addFeedItem = (item) ->
    feed_item = new FeedPost
      feed_id:          @id
      title:            item.title
      description:      item.description
      summary:          item.summary
      publication_date: item.pubdate
      author:           item.author
      link:             item['rss:link']
      source:           item.source
    feed_item.preventDuplicationAndSave (err, feedPost) ->
      if err?
        console.log 'failed to save feeditem', err
      else
        console.log 'added feedPost', feedPost.title, feedPost.feed_id
      
  FeedPost::preventDuplicationAndSave = (next) ->
    self = @
    FeedPost.findOne { title: @title, publication_date: @publication_date }, (err, feedPost) ->
      unless feedPost?
        self.save (err) -> next err, self
      else
        next null, feedPost

  Feed::onFeedReceived = (res, stream, next) ->
    if res.statusCode != 200
      next "Feed answered with status #{res.statusCode}"
    else
      stream.pipe @feed_parser

  Feed::fetchPosts = (filters, next) ->
    feed            = @
    filters.feed_id = @id
    FeedPost.find filters, (err, results) ->
      if err?
        next err
      else
        feed.feedPosts = results
        next null

  Feed::publicAttributes = (include_methods = []) ->
    obj =
      id:          @id
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
