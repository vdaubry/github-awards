class RemoveUserLogin < ActiveRecord::Migration
  def change
    remove_column :repositories, :user_login, :string
    
    change_column :repositories, :user_id, :integer, :null => false
  end
end