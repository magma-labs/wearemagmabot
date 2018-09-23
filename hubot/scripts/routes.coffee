module.exports = (robot) ->
  robot.router.post '/send-new-posts', (req, res) ->
    console.log 'Receiving posts from crawler...'

    # First, verify is this request comes from a trusted crawler
    unless req.headers['X-Application-Secret'] == process.env.APPLICATION_SECRET
      console.log 'Crawler request does not include a valid secret. UNAUTHORIZED.'
      res.status(401).send 'UNAUTHORIZED'
      return

    posts = req.body || []
    console.log 'Posts received:', posts

    if posts.length > 0
      channel = process.env.HUBOT_SLACK_CHANNEL || 'wearemagmabot'
      robot.messageRoom channel, 'Just found some #wearemagma posts!'
      # Posts the post url so Slack can render a preview of it
      robot.messageRoom channel, post.url for post in posts
      res.send 'OK'
      console.log 'Posts sent! Waiting for new posts from crawler...'

