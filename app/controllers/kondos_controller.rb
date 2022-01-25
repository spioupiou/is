class KondosController < ApplicationController
  def index
    authorize @kondos = Kondo.order(created_at: :desc)
  end

  def show
    @kondo = Kondo.find(params[:id])
  end
end
