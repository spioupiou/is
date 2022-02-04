class UpdateProfileInUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :profile, foreign_key: true, null: false
  end
end
