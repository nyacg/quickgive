class Status
  attr_accessor :campaign, :amount

  def initialize text, via
    @via = via
    hashtags = text.scan(/#\S+/)

    campaigns = hashtags.map do |hashtag|
      Campaign.first(slug: hashtag[1..-1])
    end
    @campaign = campaigns.reject(&:nil?).first
    return if @campaign.nil?

    @amount = text.match(/#[a-zA-Z]*(\d+)pounds/)[1]
  end

  def donate(donor)
    @donor = donor

    # Perform the donation
    Payment.create(amount: @amount.to_f, time: Time.now, campaign: @campaign, user: @donor, via: @via) unless @donor.nil?
  end
end
