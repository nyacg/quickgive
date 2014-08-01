#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  TweetStream::Client.new.track("#quick_give") do |status|
    begin
      puts status.text
      @status = Status.new status.text, "twitter"
      next if @status.campaign.nil?
      @donor = User.find_by_twitter_screen_name status.user.screen_name

      # If they're not registered
      if @donor.nil? and not @status.campaign.nil?
        # Send them a signup message
        puts @status.campaign.slug.inspect
        puts @status.amount.inspect
        url = "http://quickgive.rckrds.uk/twitter_donate/#{URI.escape @status.campaign.slug}/#{URI.escape @status.amount}"
        message = "Donate and sign up to QuickGive at #{url}"
        puts TWITTER_CLIENT.update("@#{status.user.screen_name} #{message} #{Time.now}", in_reply_to_status_id: status.id).inspect
      else
        @status.donate @donor
      end
    rescue Exception => e
      puts e.inspect
      print e.backtrace.join("\n")
    end
  end
  
  sleep 10
end
