class ProfilesController < ApplicationController
  skip_before_action :authenticate_user!

  def new
  end

  def show
      @user = User.find(params[:id])
      @profile = Profile.find(params[:id])
  end

  def edit
  end

  def update
  end
end
