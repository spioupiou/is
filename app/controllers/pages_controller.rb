class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    # we made sure in the seed that the first 4 kondo will always be unique from each other
    @kondos = Kondo.first(4)
  end

  def profile
  end
end
