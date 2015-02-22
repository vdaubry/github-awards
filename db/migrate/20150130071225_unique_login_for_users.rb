class UniqueLoginForUsers < ActiveRecord::Migration
  def change
    remove_index :users, :login
    add_index :users, :login, :unique => true
  end
end
