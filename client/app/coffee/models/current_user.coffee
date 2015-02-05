class Model.CurrentUser extends Backbone.Model
  url:   '/session'
  feeds: null

  initialize: ->
    @feeds = new Model.Feeds()
    @listenTo @, 'connection:success', @fetch_feeds
    @fetch_current_user()

  fetch_current_user: ->
    $.ajax
      method: 'GET'
      url:    '/api/users/current'
      success: (user) => @trigger 'connection:success', user

  connect: () ->
    $.ajax
      method: 'POST'
      url:    @url
      data:
        email:    @get 'email'
        password: @get 'password'
      success: (user) => @trigger 'connection:success', user
      error:   ()     => @trigger 'connection:failure'
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