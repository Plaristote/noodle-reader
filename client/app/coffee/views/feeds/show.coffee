class View.Feed extends Backbone.View
  template:     JST['feeds/show']
  templateItem: JST['feeds/_item']
  isLoading:    false

  events:
    'click #add-feed': 'add_feed'

  initialize: ->
    window.current_view = @
    @listenTo @model,      'change:title change:description change:link', @render
    @listenTo @model,      'change:feedPosts', @update
    @listenTo application, 'load-more', @on_load_more

  render: ->
    @$el.html @template
      feed: @model
    super

  update: ->
    @set_loading false
    for item in (@model.get 'feedPosts')
      post = @find_post_by_id item._id
      @add_feed_item item unless post?

  find_post_by_id: (id) ->
    item = @$(".feed-item[data-id=#{id}]")
    if item.length > 0 then item else null

  add_feed_item: (item) ->
    @$el.append @templateItem item: item
    
  set_loading: (loading) ->
    @isLoading = loading

  on_load_more: ->
    return if @isLoading == true
    @set_loading true
    page = if @model.has 'page'
      (@model.get 'page') + 1
    else
      0
    @model.set 'page', page