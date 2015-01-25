mongoose = require 'mongoose'
bcrypt   = require 'bcrypt'

SALT_WORK_FACTOR = 10

build_module = ->
  user_schema = new mongoose.Schema
    email:    { type: String, required: true, index: { unique: true } }
    password: { type: String, required: true }
    feeds:    { type: [String] }

  user_schema.pre 'save', (next) ->
    if @isModified 'password'
      @encryptPassword next
    else
      next()

  global.User = mongoose.model 'User', user_schema

  User::encryptPassword = (next) ->
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) =>
      unless err
        bcrypt.hash @password, salt, (err, hash) =>
          @password = hash
          next()
      else
        next()

  User::comparePasswords = (candidate, options) ->
    bcrypt.compare candidate, @password, (err, isMatch) =>
      if isMatch
        options.success()
      else
        options.failure()

  User::publicAttributes = () ->
    email: @email
    feeds: @feeds

  User::updateAttributes = (attributes) ->
    delete @[key] for key in ['email', 'id']
    @[key] = value for key,value of attributes

  User::unsubscibeFromFeed = (id, next) ->
    if id in @feeds
      @feeds = @feeds.filter (word) -> word isnt id
      @save (err) =>
        if err?
          next err
        else
          Feed.garbageCollectFeed id, ->
            console.log "feed #{id} garbage collected"
          next null, @
    else
      next null, null

  User::subscribeToFeed = (url, next) ->
    Feed.findOne { url: url }, (err, feed) =>
      if err?
        next err
      else if not feed?
        console.log 'feed not found', feed
        @createFeed url, next
      else
        console.log 'feed found', feed
        @addFeed feed, next

  User::createFeed = (url, next) ->
    user = @
    Feed.create { url: url }, (err, feed) ->
      if err?
        next err
      else
        user.addFeed feed, next

  User::addFeed = (feed, next) ->
    @feeds.push feed.id if feed.id not in @feeds
    @save (err) =>
      if err?
        next err
      else
        next null, feed

build_module() unless global.User?
