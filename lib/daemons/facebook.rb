#!/usr/bin/env ruby

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

  
# We look only at statuses that have been posted since the daemon was started
# to avoid taking payments twice
# TODO Consider this
start_time = Time.now
# Statuses that have been done
done_ids = []

# Loops over and over again
while($running) do
  # For debugging purposes
  puts "Running"

  # The time that we started this runthrough of the loop
  loop_start_time = Time.now

  # For all Facebook accounts that we have access for
  FacebookAuthentication.all.select { |fa| fa.access_token }.each do |authentication|
    # Create a new FB API client
    @koala = Koala::Facebook::API.new authentication.access_token

    # Get all statuses published by the user's account
    statuses = @koala.get_object("me/statuses").select do |status|
      # Select only statuses that include #quick_give
      # AND that have been posted since the last runthrough of this loop
      status["message"].include?("#quick_give") and Time.parse(status["updated_time"]) >= start_time
    end

    # For each of those statuses
    statuses.each do |status|
      # Create a new Status object that we'll use to parse the text
      @status = Status.new status["message"], "facebook"
      # Skip if no Campaign hashtag was found in the status
      next if @status.campaign.nil?

      # We donate based on status likes, so skip this status if there aren't
      # any likes
      next unless status.include? "likes"

      likes = status["likes"]["data"]
      likes.each do |like|
        # Make sure we don't donate from the same like twice by maintaining
        # an array of all likes that we've processed (like IDs are unique)
        # This is vital because we are processing each status posted since the
        # daemon began again and again, but ignoring the likes we've already
        # processed because of this daemon.
        next if done_ids.include? like["id"]
        done_ids.push like["id"]

        # Using the Facebook account user uid of the user that liked the status,
        # find the person who wants to donate
        @donor = User.find_by_facebook_uid like["id"]
        puts @donor.inspect

        # If they haven't signed up to QuickGive yet
        if @donor.nil?
          # Create a message asking them to sign up
          url = "http://quickgive.rckrds.uk/facebook_donate/#{URI.escape @status.campaign.slug}/#{URI.escape @status.amount}"
          message = "Donate and sign up to QuickGive at #{url}"
          # And comment that message onto the status
          # TODO This is a *really* bad way to get in contact with the person.
          # The Facebook API is very restrictive, but there must be some way
          # we can message them, or at least "tag" them in our comment so they
          # receive some sort of notification from FB.
          @koala.put_comment(status["id"], message)
          puts message
        # Otherwise if they're already a QuickGive member
        else
          # Make the donation
          @status.donate(@donor)
          puts "Donating"
          # Comment on the status telling them the donation was successful
          # TODO This has the same issues as the above @koala.put_comment
          # line; any solution found to that problem should also fix this one.
          @koala.put_comment(status["id"], "Your donation was successful!")
        end
      end
    end
  end

  # We don't want or need to hammer FB's API too hard
  sleep 5
end
