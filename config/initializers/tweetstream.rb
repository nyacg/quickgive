SOCIAL_CONFIG = YAML.load(File.read(Rails.root.join("config/twitter.yml")))

TweetStream.configure do |config|
  config.consumer_key       = SOCIAL_CONFIG["consumer_key"]
  config.consumer_secret    = SOCIAL_CONFIG["consumer_secret"]
  config.oauth_token        = SOCIAL_CONFIG["oauth_token"]
  config.oauth_token_secret = SOCIAL_CONFIG["oauth_token_secret"]
  config.auth_method        = :oauth
end

TWITTER_CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key        = SOCIAL_CONFIG["consumer_key"]
  config.consumer_secret     = SOCIAL_CONFIG["consumer_secret"]
  config.access_token        = SOCIAL_CONFIG["oauth_token"]
  config.access_token_secret = SOCIAL_CONFIG["oauth_token_secret"]
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, SOCIAL_CONFIG["consumer_key"], SOCIAL_CONFIG["consumer_secret"]
  provider :facebook, SOCIAL_CONFIG['facebook_key'], SOCIAL_CONFIG['facebook_secret'], scope: [:offline_access, :user_status]
end
