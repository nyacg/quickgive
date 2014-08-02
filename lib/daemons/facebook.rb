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

  
# TODO Very dodgy
last_ran_time = Time.now
done_ids = []

while($running) do
  puts "Running"
  FacebookAuthentication.all.select { |fa| fa.access_token }.each do |authentication|
    @koala = Koala::Facebook::API.new authentication.access_token
    statuses = @koala.get_object("me/statuses").select do |status|
      status["message"].include?("#quick_give") and Time.parse(status["updated_time"]) >= last_ran_time
    end

    statuses.each do |status|
      @status = Status.new status["message"], "facebook"
      next if @status.campaign.nil?

      next unless status.include? "likes"
      likes = status["likes"]["data"]
      likes.each do |like|
        next if done_ids.include? status["id"]
        done_ids.push status["id"]

        puts like["id"].inspect
        @donor = User.find_by_facebook_uid like["id"]
        puts @donor.inspect
        if @donor.nil?
          url = "http://quickgive.rckrds.uk/facebook_donate/#{URI.escape @status.campaign.slug}/#{URI.escape @status.amount}"
          message = "Donate and sign up to QuickGive at #{url}"
          puts message
          @koala.put_comment(status["id"], message)
        else
          @status.donate(@donor)
          puts "Donating"
          @koala.put_comment(status["id"], "Your donation was successful!")
        end
      end
    end

    last_ran_time = Time.now
  end

  sleep 5
end
