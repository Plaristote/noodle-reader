class Model.Feeds extends Backbone.Collection
  model: Model.Feed
  url: '/api/feeds'

  find_by_id: (id) ->
    @find (model) -> (model.get '_id') == id
  