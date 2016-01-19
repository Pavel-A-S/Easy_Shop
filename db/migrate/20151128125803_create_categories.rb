class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :category_type
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
