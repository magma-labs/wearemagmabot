class Unauthorized extends Error
  constructor: () ->
    super('UNAUTHORIZED')

receivePosts = (req) ->
  if req.header('X-Application-Secret') == process.env.APPLICATION_SECRET
    req.body || []
  else
    throw new Unauthorized

sendPosts = (robot, posts) ->
  channel = process.env.HUBOT_SLACK_CHANNEL || 'wearemagmabot'
  robot.messageRoom channel, 'Hey! I just found some #wearemagma posts!', () ->
    robot.messageRoom channel, post.url for post in posts

module.exports = (robot) ->
  robot.router.post '/send-new-posts', (req, res) ->
    try
      robot.logger.debug 'Receiving posts from crawler...'

      posts = receivePosts(req)
      robot.logger.debug 'Posts received:', posts

      sendPosts(robot, posts)
      robot.logger.debug 'Posts sent! Waiting for new posts from crawler...'
      res.send 'Posts sent!'
    catch err
      if err instanceof Unauthorized
        robot.logger.debug "An error ocurred: #{err.message}"
        res.status(401).send err.message
      else
        throw err
