class CreateMainPhotos < ActiveRecord::Migration
  def change
    create_table :main_photos do |t|
      t.string :photo
      t.integer :main_description_id

      t.timestamps null: false
    end
  end
end
