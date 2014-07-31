class CharitiesController < ApplicationController
  def index
    charities = ["Gingers Charity", "Save the Blondes", "Brunettes are Hot", "We All Love Readheads"]
    charities.map! do |charity|
      {
        name: charity
      }
    end

    render :json => charities
  end
end
