# #!/usr/bin/env ruby

# You might want to change this
# ENV["RAILS_ENV"] ||= "development"

# root = File.expand_path(File.dirname(__FILE__))
# root = File.dirname(root) until File.exists?(File.join(root, 'config'))
# Dir.chdir(root)

# require File.join(root, "config", "environment")

# $running = true
# Signal.trap("TERM") do 
  # $running = false
# end

# while($running) do
  TweetStream::Client.new.track("#quick_give") do |status|
    puts status.user.screen_name.inspect
    hashtags = status.text.scan(/#\S+/)
    campaigns = hashtags.map do |hashtag|
      Campaign.first(slug: hashtag[1..-1])
    end
    @campaign = campaigns.reject(&:nil?).first
    next if @campaign.nil?

    @donor = Donor.find_by_twitter_username status.user.screen_name
    if @donor.nil?
      # Send them a signup message
      message = "You need to get yo ass to QuickGive and give us your card details"
    else
      # Take their godamn money and tweet them telling them that!!
      message = "Thanks for donating!"
    end
    TWITTER_CLIENT.update("@#{status.user.screen_name} #{message} #{Time.now}", in_reply_to_status_id: status.id)
  end
  
  # sleep 10
# end
