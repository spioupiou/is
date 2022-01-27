class ChangeConfirmedToStatusInBookings < ActiveRecord::Migration[6.0]
  def change
    # change column name from `confirmed` to `status`
    rename_column :bookings, :confirmed, :status

    # updating the status column's type
    # for booking status the enums will be "waiting", "confirmed", "declined", "completed"
    change_column :bookings, :status, :string, null: false, default: 'waiting'
  end
end