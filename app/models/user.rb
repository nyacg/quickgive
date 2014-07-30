class User
  include MongoMapper::Document

  many :campaigns
  many :authentications

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

  def facebook_authentication?
    authentications.any? { |a| a.is_a? FacebookAuthentication }
  end

  def instagram_authentication?
    authentications.any? { |a| a.is_a? InstagramAuthentication }
  end
end
