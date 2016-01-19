class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :photo
      t.string :name
      t.text :description
      t.integer :count
      t.decimal :price
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
