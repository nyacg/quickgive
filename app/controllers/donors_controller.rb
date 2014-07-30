class DonorsController < ApplicationController
  # POST /donors/create
  def create
    # raise params.inspect
    # @donor = Donor.new service: :twitter, username: params[:twitter]
    # if @donor.save
      # redirect_to root_path
    # else
      # message = "Error(s): " + @donor.errors.map {|k,v| "#{k}: #{v}"}.join(",")
      # redirect_to root_path, flash: {error: message}
    # # end
  end

  # GET /donors/new
  def new
  end
end
