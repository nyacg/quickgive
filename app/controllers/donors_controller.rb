class DonorsController < ApplicationController
  def create
    donor = Donor.find_or_create_by_twitter_username params[:twitter_username]

    render json: {status: "Successful"}
  end

  def new
  end
end
