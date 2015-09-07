class AddUserType < ActiveRecord::Migration
  def change
    add_column :users, :organization, :boolean, index: true, null: false, default: false
  end
end
