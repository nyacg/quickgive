# Load config/twitter.yml and turn it into a Ruby hash we can extract
# API keys from
SOCIAL_CONFIG = YAML.load(File.read(Rails.root.join("config/twitter.yml")))

# Configure TweetStream (the library we're using to access the streaming API)
TweetStream.configure do |config|
  config.consumer_key       = SOCIAL_CONFIG["consumer_key"]
  config.consumer_secret    = SOCIAL_CONFIG["consumer_secret"]
  config.oauth_token        = SOCIAL_CONFIG["oauth_token"]
  config.oauth_token_secret = SOCIAL_CONFIG["oauth_token_secret"]
  config.auth_method        = :oauth
end

# Configure the bog standard Twitter API builder
TWITTER_CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key        = SOCIAL_CONFIG["consumer_key"]
  config.consumer_secret     = SOCIAL_CONFIG["consumer_secret"]
  config.access_token        = SOCIAL_CONFIG["oauth_token"]
  config.access_token_secret = SOCIAL_CONFIG["oauth_token_secret"]
end

# Configure Omniauth (the middleware that handles OAuth things)
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, SOCIAL_CONFIG["consumer_key"], SOCIAL_CONFIG["consumer_secret"]
  provider :facebook, SOCIAL_CONFIG['facebook_key'], SOCIAL_CONFIG['facebook_secret'], scope: [:offline_access, :user_status, :publish_actions]
  provider :instagram, SOCIAL_CONFIG['instagram_id'], SOCIAL_CONFIG['instagram_secret']
end
