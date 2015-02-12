mongoose = require 'mongoose'
bcrypt   = require 'bcrypt'

mongoose.connect 'mongodb://localhost/test'

require './user'
require './feed'
require './feed_post'