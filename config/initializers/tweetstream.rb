TWITTER_CONFIG = YAML.load(File.read(Rails.root.join("config/twitter.yml")))

TweetStream.configure do |config|
  config.consumer_key       = TWITTER_CONFIG["consumer_key"]
  config.consumer_secret    = TWITTER_CONFIG["consumer_secret"]
  config.oauth_token        = TWITTER_CONFIG["oauth_token"]
  config.oauth_token_secret = TWITTER_CONFIG["oauth_token_secret"]
  config.auth_method        = :oauth
end

TWITTER_CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key        = TWITTER_CONFIG["consumer_key"]
  config.consumer_secret     = TWITTER_CONFIG["consumer_secret"]
  config.access_token        = TWITTER_CONFIG["oauth_token"]
  config.access_token_secret = TWITTER_CONFIG["oauth_token_secret"]
end
