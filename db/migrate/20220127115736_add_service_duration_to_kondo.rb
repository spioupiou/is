class AddServiceDurationToKondo < ActiveRecord::Migration[6.0]
  def change
    add_column :kondos, :service_duration, :integer
  end
end
