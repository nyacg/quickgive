#!/usr/bin/env ruby

# This file can't be called twitter.rb because it breaks things; presumably
# because of a require 'twitter' somewhere that gets confused between
# this twitter.rb and the 'twitter' API library

# Set rails environment to development if it's not set already
# TODO Change this. At the moment we're using development for literally everything,
# but at some point we should probably move to using development for development
# and production for live things as intended.
ENV["RAILS_ENV"] ||= "development"

# Daemon boilerplate
root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

# Loops over and over again, although actually we'll always stay in the first loop
# because TweetStream.track never returns
while($running) do
  # Create a new Twitter stream client that gets all (up to a certain rate limit)
  # --- TODO Check we won't hit this rate limit if we get popular ---
  # tweets with the #quick_give hashtag in
  TweetStream::Client.new.track("#quick_give") do |status|
    begin
      # For debugging purposes, print out the tweet
      puts status.text

      # Use the Status class to process the tweet text
      @status = Status.new status.text, "twitter"

      # Skip if no Campaign hashtag was found in the status
      next if @status.campaign.nil?

      # Find the user that posted the tweet
      @donor = User.find_by_twitter_screen_name status.user.screen_name

      # If that user's not registered with QuickGive
      if @donor.nil?
        # Create a message asking them to signup to send
        # DO NOT PUT THE TIME AT THE END OF THIS MESSAGE, IT MAJORLY MAJORLY
        # MESSES THINGS UP AND TWITTER PERMABLOCK US FROM THEIR API
        url = "http://quickgive.rckrds.uk/twitter_donate/#{URI.escape @status.campaign.slug}/#{URI.escape @status.amount}"
        message = "Donate at #{url}"
        # Using the bog standard Ruby twitter API client, tweet that message
        # at the user. We send it in reply to the initial tweet so it comes
        # up as a reply and hence they get a notification even if they're
        # not following us.
        puts TWITTER_CLIENT.update("@#{status.user.screen_name} #{message}", in_reply_to_status_id: status.id).inspect
      # Otherwise if they're already a QuickGive member
      else
        # Donate! The Payment and User models take care of all the hard stuff
        # for us.
        @status.donate @donor
      end
    # TweetStream seems to (somewhat sensibly) capture all errors and silently
    # ignore them, which is good for production but rather annoying for
    # development. So here we capture any errors, and print them out (but still
    # carry on executing).
    rescue Exception => e
      puts e.inspect
      print e.backtrace.join("\n")
    end
  end
  
  # If the twitter streaming client crashes for some reason, we probably want
  # to give Twitter's API a little break so that we're not continually pounding
  # them if the streaming client always crashes. Hence a delay of 10 seconds.
  sleep 10
end
