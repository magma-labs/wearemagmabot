## Bot that tracks #wearemagma in social media

### Architecture
  * A [hubot](https://hubot.github.com) instance:
      * Receives web requests from crawler
      * Posts messages to Slack channel
      * Answers questions about crawler status (2nd iteration)
      * Restarts crawler on demand (2nd iteration)
      * Answers stats questions from Slack (nice-to-have)
      * Web UI (future iterations)
  * A crawler app:
      * Does crawling of Twitter, Facebook and Instagram feeds
      * Commands hubot instance to post links in Slack channel via web requests
      * Can be restarted via the hubot instance (2nd iteration)
      * Looks for multiple hashtags (2nd iteration)
      * Stores stats in database (nice-to-have)
  * A [redis](https://redis.io) database:
      * Required by hubot instance
      * Stores hashtag stats (nice-to-have)

### Deploys as
  * web: hubot instance
  * worker: crawler app

### Authors
  * [kevinnio](https://github.com/kevinnio)

Checkout MagmaLabs on [Twitter](https://twitter.com/weareMagmaLabs), [Facebook](https://www.facebook.com/magmalabsio) and [Instagram](https://www.instagram.com/magmalabs)!
