#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

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

while($running) do
  puts "Running"
  FacebookAuthentication.all.select { |fa| fa.access_token }.each do |authentication|
    @koala = Koala::Facebook::API.new authentication.access_token
    statuses = @koala.get_object("me/statuses").select do |status|
      status["message"].include?("#quick_give") and Time.parse(status["updated_time"]) >= last_ran_time
    end

    statuses.each do |status|
      @status = Status.new status["message"], "facebook"
      @donor = User.find_by_facebook_uid status["from"]["id"]
      next if @donor.nil? or @status.campaign.nil?
      @status.donate(@donor)
      @koala.put_comment(status["id"], "My donation was successful!!")
    end

    last_ran_time = Time.now
  end

  sleep 5
end
