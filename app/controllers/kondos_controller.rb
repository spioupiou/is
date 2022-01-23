class KondosController < ApplicationController
  def index
    @kondos = Kondo.order(created_at: :desc)
  end
end
