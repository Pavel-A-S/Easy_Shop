class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_name
      t.string :customer_id
      t.string :customer_name
      t.string :phone
      t.string :email
      t.string :customer_login
      t.text :description
      t.text :status_description

      t.timestamps null: false
    end
  end
end
