class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :kondo, null: false, foreign_key: true
      t.boolean :confirmed
      t.datetime :booked_date

      t.timestamps
    end
  end
end
