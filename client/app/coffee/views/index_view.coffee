class View.Index extends ApplicationView
  template: JST['index']

  initialize: ->
    @mode = if @user? then 'edit' else 'create'
    @user = @user || new Model.User()

  render: ->
    @$el.html @template()
    super
