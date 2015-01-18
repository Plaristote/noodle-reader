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

build_module() unless global.Feed?
