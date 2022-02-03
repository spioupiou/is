class RemoveUserIdFromProfile < ActiveRecord::Migration[6.0]
  def change
    remove_column :profiles, :user_id, :bigint
  end
end
