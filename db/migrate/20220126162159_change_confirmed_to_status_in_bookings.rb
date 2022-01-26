class ChangeConfirmedToStatusInBookings < ActiveRecord::Migration[6.0]
  
  # change column name from confirmed to status
  def change
    rename_column :bookings, :confirmed, :status
    # for booking status the enums will be "waiting", "confirmed", "declined", "completed"
    change_column :bookings, :status, :string, null: false, default: 'waiting'
  end
end