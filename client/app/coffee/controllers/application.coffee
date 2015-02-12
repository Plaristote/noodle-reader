class Controller.Application extends Backbone.Router
  routes:
    'index': 'index'
    
  index: ->
    view = new View.Index
    view.render()
    $('#page').empty().append view.$el