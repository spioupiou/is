class KondosController < ApplicationController
  def index
    @kondos = Kondo.order(created_at: :desc)
    unless params[:search_kondos] == ""
      @kondos = @kondos.where("LOWER(prefecture) like ?","%#{params[:search_kondos].to_s.downcase}%")
    else
      @kondos = Kondo.all
    end
  end

  def show
    @kondo = Kondo.find(params[:id])
  end
end
