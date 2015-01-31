window.Model      = {}
window.View       = {}
window.Controller = {}

window.application = new class
  constructor: ->
    _.extend @, Backbone.Events
    $(document).ready => @initialize()

  initialize: ->
    @setup_backbone()
    @current_user = new Model.CurrentUser()
    @main_view    = new MainView()
    @setup_controllers()
    @trigger 'ready'

  setup_backbone: ->
    Backbone.$ = jQuery

  setup_controllers: ->
    @session_controller = new Controller.Session()
    @users_controller   = new Controller.Users()
    @feeds_controller   = new Controller.Feeds()
    Backbone.history.start()

class window.ApplicationView extends Backbone.View
  render: ->
    $('#page').empty().append @$el
    @

  $: (param) -> $(param, @$el)
  
class window.ApplicationModel extends Backbone.Model
  save: ->
    super null,
      success: => @trigger 'saved:success'
      error:   => @trigger 'saved:failure'