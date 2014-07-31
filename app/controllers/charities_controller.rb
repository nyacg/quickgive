class CharitiesController < ApplicationController
  def search
    @charities = Charity.search params[:query]
    @charities.map! &:title
    render json: @charities
  end
end
