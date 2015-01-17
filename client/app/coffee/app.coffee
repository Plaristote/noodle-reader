window.Model      = {}
window.View       = {}
window.Controller = {}

window.application = new class
  constructor: ->
    _.extend @, Backbone.Events
    $(document).ready => @initialize()

  initialize: ->
    @current_user = new Model.CurrentUser()
    @setup_controllers()
    @setup_backbone()
    @trigger 'ready'

  setup_backbone: ->
    Backbone.$ = jQuery
    Backbone.history.start()

  setup_controllers: ->
    @session_controller = new Controller.Session()
    @users_controller   = new Controller.Users()

class window.ApplicationView extends Backbone.View
  render: ->
    $('#page').empty().append @$el

  $: (param) -> $(param, @$el)
  
class window.ApplicationModel extends Backbone.Model
  save: ->
    super null,
      success: => @trigger 'saved:success'
      error:   => @trigger 'saved:failure'