class KondosController < ApplicationController
  def index
     @kondos = policy_scope(Kondo).order(created_at: :desc)
  end

  def show
    @kondo = Kondo.find(params[:id])
  end

end
