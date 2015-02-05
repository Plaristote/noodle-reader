class Controller.Feeds extends Backbone.Router
  routes:
    'feeds/:id': 'show'

  show: (id) ->
    feed = application.current_user.feeds.find_by_id id
    view = new View.Feed model: feed
    view.render()
    view.on_load_more()
    $('#page').empty().append view.$el