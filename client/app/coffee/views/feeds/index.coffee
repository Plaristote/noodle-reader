class View.FeedIndex extends Backbone.View
  template: JST['feeds/index']

  events:
    'click #add-feed': 'add_feed'

  initialize: ->
    $('#sidebar').empty().append @$el
    @listenTo application.current_user.feeds, 'change', @render
    @listenTo application.current_user.feeds, 'add',    @render
    @listenTo application.current_user.feeds, 'remove', @render

  render: ->
    @$el.html @template
      feeds: application.current_user.feeds
    @

  add_feed: ->
    feed_url = prompt 'Please enter a feed url'
    if feed_url?
      feed = new Model.Feed url: feed_url
      @listenToOnce feed, 'saved:success', -> application.current_user.feeds.add feed
      @listenToOnce feed, 'saved:failure', -> alert "Could not add feed #{feed_url}"
      feed.save()
