class View.Feed extends Backbone.View
  template:     JST['feeds/show']
  templateItem: JST['feeds/_item']
  
  events:
    'click #add-feed': 'add_feed'

  initialize: ->
    window.current_view = @
    @listenTo @model, 'change:title change:description change:link', @render
    @listenTo @model, 'change:feedPosts', @update

  render: ->
    @$el.html @template
      feed: @model
    super

  update: ->
    for item in (@model.get 'feedPosts')
      post = @find_post_by_id item._id
      @add_feed_item item unless post?

  find_post_by_id: (id) ->
    item = @$(".feed-item[data-id=#{id}]")
    if item.length > 0 then item else null

  add_feed_item: (item) ->
    @$el.append @templateItem item: item