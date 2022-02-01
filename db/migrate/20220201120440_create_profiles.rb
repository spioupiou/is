class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :job_title
      t.string :about_me
      t.integer :years_of_exp
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
