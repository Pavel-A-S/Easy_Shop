class AddCredentialsToUser < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer, default: 0
    add_column :users, :name, :string
    add_column :users, :phone, :string
  end
end
