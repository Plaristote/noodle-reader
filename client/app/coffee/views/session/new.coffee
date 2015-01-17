class View.SessionNew extends ApplicationView
  template: JST['session/new']
  events:
    'click button.connect': 'connect'

  initialize: ->
    @listenTo application.current_user, 'connection:success', @onConnectionSuccess
    @listenTo application.current_user, 'connection:failure', @onConnectionFailed
    @listenTo application.current_user, 'connection:loading', @onConnectionStarted

  render: ->
    @$el.html @template()
    super
    
  connect: ->
    @trigger 'connect', @userData()

  userData: ->
    email:    @$('input[name="email"]').val()
    password: @$('input[name="password"]').val()

  onConnectionStarted: ->
    @$('.loading-helper').show()

  onConnectionSuccess: ->
    @onConnectionFinished()

  onConnectionFailed: ->
    @onConnectionFinished()
    @$('.flash-error').text 'Invalid credentials'
    
  onConnectionFinished: ->
    @$('.loading-helper').hide()
