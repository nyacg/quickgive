class CharitiesController < ApplicationController
  # Use the full-text search implemented in the Charity model
  # to search for matching Charities and return a JSON array of them
  def search
    @charities = Charity.search params[:query]

    # Turn each charity into just it's title
    @charities.map! &:title
    # Make sure the casing is proper on all of the charities
    # (i.e. "COMIC RELIEF" -> "Comic Relief")
    @charities.map! &:titleize

    render json: @charities
  end
end
