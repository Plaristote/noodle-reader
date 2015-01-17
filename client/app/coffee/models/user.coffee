class Model.User extends ApplicationModel
  url: '/api/users'
  schema:
    email:            { type: 'Text',     validators: [ 'required', 'email' ] }
    password:         { type: 'Password', validators: [ 'required', { type: 'match', field: 'confirm_password', message: 'passwords don\'t match' } ] }
    confirm_password: { type: 'Password' }
