mongoose = require 'mongoose'

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
    feed_id:          { type: String }
    title:            { type: String }
    category:         { type: String }
    link:             { type: String }
    description:      { type: String }
    publication_date: { type: Date   }
    source:           { type: String }
    created_at:       { type: Date   }

  global.FeedPost = mongoose.model 'FeedPost', feed_post_schema

  Feed::fetch_posts = () ->
    null

  Feed::posts = (filters = {}) ->
    filters.feed_id = @id
    FeedPost.find filters

build_module() unless global.Feed?
