class Model.Feed extends Backbone.Model
  url: -> "/api/feeds/#{@get '_id'}"
