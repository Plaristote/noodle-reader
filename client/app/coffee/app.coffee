window.Model      = {}
window.View       = {}
window.Controller = {}

window.application = new class
  constructor: ->
    _.extend @, Backbone.Events
    $(document).ready => @initialize()

  initialize: ->
    location.hash = 'index' if location.hash == ''
    @setup_backbone()
    @current_user = new Model.CurrentUser()
    @main_view    = new MainView()
    @setup_controllers()
    @setup_application_events()
    @trigger 'ready'

  setup_backbone: ->
    Backbone.$ = jQuery

  setup_controllers: ->
    @app_controller     = new Controller.Application()
    @session_controller = new Controller.Session()
    @users_controller   = new Controller.Users()
    @feeds_controller   = new Controller.Feeds()
    Backbone.history.start()

  setup_application_events: ->
    $(window).scroll => @on_window_scroll()

  on_window_scroll: ->
    @trigger 'load-more' if $(document).height() - $(window).scrollTop() - window.innerHeight < 10

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