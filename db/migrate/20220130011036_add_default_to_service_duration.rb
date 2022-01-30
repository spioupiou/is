class AddDefaultToServiceDuration < ActiveRecord::Migration[6.0]
  def change
    change_column_default :kondos, :service_duration, from: nil, to: 1
  end
end
