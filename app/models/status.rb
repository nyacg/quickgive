# Not actually linked to any stored data in mongo or anywhere, but is instead
# used as a convenient class for parsing things out of and making payments from
# a social media status (e.g., a tweet).
class Status
  attr_accessor :campaign, :amount

  # Create from the status text (e.g., the tweet contents), and a "via" string:
  # either "twitter" or "facebook", etc
  def initialize text, via
    # Store for later because it's needed in Robert's magicy JS ui
    @via = via

    # Get an array of all hashtags in the status
    hashtags = text.scan(/#\S+/)

    # For each hashtag, attempt to find a Campaign with a slug matching that
    # hashtag
    campaigns = hashtags.map do |hashtag|
      Campaign.first(slug: hashtag[1..-1])
    end
    # Find the first non-nil Campaign (i.e. the one we actually have stored in
    # the DB)
    @campaign = campaigns.reject(&:nil?).first
    return if @campaign.nil?

    # See if we can extract the amount the user wants to donate from a hashtag
    # e.g. if #50pounds or #donate50pounds is present in text, then @amount = "50A"
    @amount = text.match(/#[a-zA-Z]*(\d+)pounds/)[1]
  end

  # Perform a donation based upon the status
  # The user who's donating is passed in as donor
  def donate(donor)
    @donor = donor

    # Perform the donation
    Payment.create(amount: @amount.to_f, time: Time.now, campaign: @campaign, user: @donor, via: @via) unless @donor.nil?
  end
end
