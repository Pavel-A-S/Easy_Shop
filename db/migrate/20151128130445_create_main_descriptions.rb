class CreateMainDescriptions < ActiveRecord::Migration
  def change
    create_table :main_descriptions do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
