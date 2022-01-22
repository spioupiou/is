class CreateKondos < ActiveRecord::Migration[6.0]
  def change
    create_table :kondos do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.text :summary
      t.text :details
      t.string :prefecture
      t.integer :price

      t.timestamps
    end
  end
end
