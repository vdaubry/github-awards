class AddIndexLocationToUser < ActiveRecord::Migration
  def change
    add_index :users, [:login, :city]
    add_index :users, [:login, :country]
  end
end
