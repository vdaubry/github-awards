class AddGithubIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :github_id, :integer, null: false
    
    add_index :users, :github_id
  end
end
