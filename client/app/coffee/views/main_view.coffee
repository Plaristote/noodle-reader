class window.MainView extends Backbone.View
  initialize: ->
    @listenTo application.current_user, 'connection:success',    @hide_userspace
    @listenTo application.current_user, 'disconnection:success', @show_userspace

  show_userspace: ->
    $('#user-space').show()

  hide_userspace: ->
    $('#user-space').hide()