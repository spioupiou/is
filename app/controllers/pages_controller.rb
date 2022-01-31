class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @kondos = Kondo.all.sample(4)
  end

  def profile
  end
end
