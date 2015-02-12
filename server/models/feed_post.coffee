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

  FeedPost::preventDuplicationAndSave = (next) ->
    self = @
    FeedPost.findOne { title: @title, publication_date: @publication_date }, (err, feedPost) ->
      unless feedPost?
        self.save (err) -> next err, self
      else
        next null, feedPost
  
build_module() unless global.FeedPost?