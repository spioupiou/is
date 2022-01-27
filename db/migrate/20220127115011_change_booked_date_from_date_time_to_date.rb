class ChangeBookedDateFromDateTimeToDate < ActiveRecord::Migration[6.0]
  def change
    change_column :bookings, :booked_date, :date, null: false
  end
end
