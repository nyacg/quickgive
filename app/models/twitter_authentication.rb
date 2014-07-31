class TwitterAuthentication < Authentication
  include MongoMapper::Document

  belongs_to :user

  key :uid, String, required: true

  def screen_name
    TWITTER_CLIENT.user(uid.to_i).screen_name
  end

  def self.uid_of_screen_name(screen_name)
    TWITTER_CLIENT.user(screen_name).id
  end
end
