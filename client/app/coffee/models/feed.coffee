class Model.Feed extends Backbone.Model
  idAttribute:  '_id'
  urlRoot:      '/api/feeds'
  itemsPerPage: 10
  defaults:
    page: 0

  initialize: ->
    @on 'change:feedPosts', @sortPosts, @
    @on 'change:page',  @loadNewPage, @

  url: ->
    "#{@urlRoot}/#{@get @idAttribute}?#{@urlParameters()}"
    
  urlParameters: ->
    options =
      page:         @get 'page'
      itemsPerPage: @itemsPerPage
    if (@has 'feedPosts') and @attributes.feedPosts.length > 0
      earliest_date = moment @attributes.feedPosts[0].publicaiton_date
      options.from  = earliest_date.unix() * 1000
    $.param options

  sortPosts: ->
    _.sortBy @attributes.feedPosts, (post) -> moment(post.publication_date).unix()

  loadNewPage: ->
    $.ajax
      method: 'GET'
      url:    @url()
      success: (result) => @merge result

  merge: (object) ->
    @set 'feedPosts', [] unless @has 'feedPosts'
    @set 'feedPosts', _.union (@get 'feedPosts'), object.feedPosts
    delete object.feedPosts
    @set object
