class Donor
  include MongoMapper::Document

  many :payments
  key :twitter_username,  String

  def self.find_or_create_by_twitter_username username
    donor = Donor.first twitter_username: username
    donor = Donor.create twitter_username: username if donor.nil?
    return donor
  end
end
