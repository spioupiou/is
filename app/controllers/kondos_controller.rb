class KondosController < ApplicationController
  def index
    #Renter's Page
    if current_user.renter?
      @kondos = Kondo.order(created_at: :desc)

      unless params[:search_kondos] == ""
        @kondos = @kondos.where("LOWER(prefecture) like ?","%#{params[:search_kondos].to_s.downcase}%")
      else
        @kondos = Kondo.all
      end

    end
    #Provider's Page
    if current_user.provider?
      @kondos = Kondo.where(user_id: current_user.id)
    end

  end

  def show
    @kondo = Kondo.find(params[:id])
  end
end
