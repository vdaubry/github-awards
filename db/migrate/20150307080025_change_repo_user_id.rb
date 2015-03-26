class ChangeRepoUserId < ActiveRecord::Migration
  def change
    rename_column :repositories, :user_id, :user_login
    add_column :repositories, :user_id, :integer
  end
end
