class Controller.Feeds extends Backbone.Router
  routes:
    'feeds/:id':             'show'
    'feeds/:id/unsubscribe': 'destroy'

  show: (id) ->
    feed = application.current_user.feeds.find_by_id id
    view = new View.Feed model: feed
    view.render()
    view.on_load_more()
    $('#page').empty().append view.$el

  destroy: (id) ->
    feed = application.current_user.feeds.find_by_id id
    feed.destroy()
    @navigate '/index', trigger: true