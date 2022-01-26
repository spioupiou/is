class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @kondos = Kondo.all.first(4)
  end

  def profile
  end
end
