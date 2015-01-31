class Model.CurrentUser extends Backbone.Model
  url:   '/session'
  feeds: []
  
  initialize: ->
    @feeds = new Model.Feeds()
    @listenTo @, 'connection:success', @fetch_feeds

  connect: () ->
    $.ajax
      method: 'POST'
      url:    @url
      data:
        email:    @get 'email'
        password: @get 'password'
      success: => @trigger 'connection:success'
      error:   => @trigger 'connection:failure'
    @trigger 'connection:loading'

  disconnect: () ->
    $.ajax
      method: 'DELETE'
      url:    @url
      success: => @trigger 'disconnection:success'
      error:   => @trigger 'disconnection:failure'
    @trigger 'disconnection:loading'

  fetch_feeds: () ->
    @feeds.fetch()