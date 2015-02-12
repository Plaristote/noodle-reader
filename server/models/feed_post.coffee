mongoose   = require 'mongoose'
request    = require 'request'

build_module = ->
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

  feed_post_schema.pre 'save', (next) ->
    @created_at = new Date() unless @created_at?
    next()

  global.FeedPost = mongoose.model 'FeedPost', feed_post_schema
  
  FeedPost.findOrCreate = (feed, item, next) ->
    feed_id = feed.id
    FeedPost.findOne { title: item.title, publication_date: item.pubdate, feed_id: feed_id }, (err, feedPost) ->
      return next err, null if err?
      feedPost = new FeedPost feed_id: feed_id unless feedPost?
      feedPost.updateFieldsFromItem item, next
        
  FeedPost::updateFieldsFromItem = (item, next) ->
    @title            = item.title
    @description      = item.description
    @summary          = item.summary
    @publication_date = item.pubdate
    @author           = item.author
    @link             = item['rss:link']['#']
    @source           = item.source
    next null, this

  FeedPost::preventDuplicationAndSave = (next) ->
    self = @
    FeedPost.findOne { title: @title, publication_date: @publication_date }, (err, feedPost) ->
      unless feedPost?
        self.save (err) -> next err, self
      else
        next null, feedPost
  
build_module() unless global.FeedPost?