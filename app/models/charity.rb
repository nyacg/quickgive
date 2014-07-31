class Charity
  include MongoMapper::Document

  key :title, String
  key :charity_number, Integer
  key :activities, String
  key :contact_name, String
  key :address, String
  key :website, String
  key :telephone, String
  key :date_registered, String
  key :date_removed, String
  key :accounts_date, String
  key :spending, String
  key :income, String
  key :company_number, String
  key :openlylocal_url, String
  key :twitter_account_name, String
  key :facebook_account_name, String
  key :youtube_account_name, String
  key :feed_url, String
  key :charity_classification_uids, String
  key :signed_up_for_1010, String
  key :last_checked, String
  key :created_at, String
  key :updated_at, String

  def self.search(query)
    where({"$text" => {"$search" => query}}).limit(10).all
  end
end
