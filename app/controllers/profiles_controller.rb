class ProfilesController < ApplicationController
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
