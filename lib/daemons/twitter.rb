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
    @status = Status.new status.text, "twitter"
    @donor = User.find_by_twitter_screen_name status.user.screen_name

    # If they're not registered
    if @donor.nil and not @status.campaign.nil?
      # Send them a signup message
      url = "http://localhost:3000/twitter_donate/#{URI.escape @campaign.slug}/#{URI.escape @amount}"
      message = "Donate at #{url}"
      puts message
      puts TWITTER_CLIENT.update("@#{status.user.screen_name} #{message} #{Time.now}", in_reply_to_status_id: status.id).inspect
    else
      @status.donate @donor
    end
  end
  
  # sleep 10
# end
