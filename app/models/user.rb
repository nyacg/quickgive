class User
  include MongoMapper::Document

  many :campaigns
  many :authentications
  many :payments

  key :first_name,    String
  key :last_name,     String
  key :type,          String, required: true # campaigner or donor

  def self.new_campaigner(params = {})
    @campaigner = new params
    @campaigner.type = "campaigner"
    @campaigner
  end

  def self.new_donor
    @donor = new
    @donor.type = "donor"
    @donor
  end

  def campaigner?
    type == "campaigner"
  end

  def twitter_authentication?
    authentications.any? { |a| a.is_a? TwitterAuthentication }
  end

  def twitter_authentication
    authentications.select { |a| a.is_a? TwitterAuthentication }.first
  end

  def facebook_authentication?
    authentications.any? { |a| a.is_a? FacebookAuthentication }
  end

  def instagram_authentication?
    authentications.any? { |a| a.is_a? InstagramAuthentication }
  end

  def notify(message)
    puts message.inspect
    if twitter_authentication?
      screen_name = authentications.select { |a| a.is_a? TwitterAuthentication }.first.screen_name
      puts TWITTER_CLIENT.update("@#{screen_name} #{message} #{Time.now}").inspect
    end
  end

  def self.find_by_twitter_screen_name(screen_name)
    uid = TwitterAuthentication.uid_of_screen_name(screen_name)
    all.select { |u| u.twitter_authentication.uid == uid }.first
  end
end
