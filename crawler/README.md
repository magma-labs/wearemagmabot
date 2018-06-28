# wearemagmabot: Crawler app

### Setup

#### Environment variables

    TWITTER_CONSUMER_KEY="<your twitter consumer key>"
    TWITTER_CONSUMER_SECRET="<your twitter consumer secret>"
    TWITTER_ACCESS_TOKEN="<your twitter access token>"
    TWITTER_ACCESS_SECRET="<your twitter access secret>"

    ENVIRONMENT=development
    HUBOT_URL="http://localhost:8080"
    CRAWLER_SLEEPTIME_IN_SECONDS=1800 // 1/2 hour
    APPLICATION_SECRET="your-secret"


#### Install

    cd crawler // from project root
    bundle install
    rspec // optional, needs to setup environment variables first

#### Launch

    bundle exec sidekiq -c ./config/sidekiq.yml -r config/environment.rb
