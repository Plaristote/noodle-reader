class Controller.Users extends Backbone.Router
  routes:
    'users':          'index'
    'users/new':      'new'
    'users/:id':      'show'
    'users/:id/edit': 'edit'

  index: ->
    alert 'index'

  show: (id) ->
    user = new Model.User id: id
    user.fetch
      success: =>
        console.log user
      error: =>
        @not_found user

  new: ->
    view = new View.UserForm()
    view.render()
    @listen_to_form view

  edit: (id) ->
    user = new Model.User id: id
    user.fetch
      success: =>
        view = new View.UserForm user: user
        view.render()
        @listen_to_form view
      error: =>
        @not_found user

  listen_to_form: (view) ->
    @listenTo view,      'commit', @commit
    @listenTo view.user, 'saved:success', => alert 'save success'
    @listenTo view.user, 'saved:failure', => alert 'save failure'

  commit: (user) ->
    user.save()

  not_found: (user) ->
    alert "User #{user.get 'id'} does not exist"