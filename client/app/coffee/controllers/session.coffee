class Controller.Session extends Backbone.Router
  routes:
    'session/new': 'new'

  new: ->
    view = new View.SessionNew()
    @listenTo view, 'connect', @create
    view.render()

  create: (userData) ->
    console.log 'Connecting user', userData
    application.current_user.set 'email',    userData.email
    application.current_user.set 'password', userData.password
    application.current_user.connect()
