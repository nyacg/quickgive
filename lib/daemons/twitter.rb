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
    puts hashtags.inspect
    campaigns = hashtags.map do |hashtag|
      Campaign.first(slug: hashtag[1..-1])
    end
    puts campaigns.inspect
    @campaign = campaigns.reject(&:nil?).first
    next if @campaign.nil?

    puts @campaign.title

    puts status.text.inspect
    @amount = status.text.match(/#[a-zA-Z]*(\d+)pounds/)[1]

    puts @amount

    puts status.user.screen_name.inspect
    @donor = User.find_by_twitter_screen_name status.user.screen_name
    if @donor.nil?
      puts "not nil"
      # Send them a signup message
      url = "http://localhost:3000/twitter_donate/#{URI.escape @campaign.slug}/#{URI.escape @amount}"
      message = "Donate at #{url}"
      puts message
      puts TWITTER_CLIENT.update("@#{status.user.screen_name} #{message} #{Time.now}", in_reply_to_status_id: status.id).inspect
    else
      # Perform the donation
      Payment.create amount: @amount.to_f, time: Time.now, campaign: @campaign, user: @donor
    end
  end
  
  # sleep 10
# end
