class View.UserForm extends ApplicationView
  template: JST['users/form']
  
  events:
    'click button[type="submit"]': 'submit'
    
  initialize: ->
    @mode = if @user? then 'edit' else 'create'
    @user = @user || new Model.User()

  render: ->
    @$el.html @template()
    @form = new Backbone.Form
      model:        @user
      submitButton: @mode
    @form.render()
    @$('.new-user').append @form.$el
    @$('.new-user button').addClass 'btn btn-success'
    super

  submit: (event) ->
    event.preventDefault()
    errors = @form.commit validate: true
    @trigger 'commit', @user unless errors?
