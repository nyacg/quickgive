class CharitiesController < ApplicationController
  def search
    @charities = Charity.search params[:query]
    @charities.map! &:title
    @charities.map! &:titleize
    render json: @charities
  end
end
