class RemoveGithubIdIndex < ActiveRecord::Migration
  def change
    change_column :users, :github_id, :integer, null: true
    change_column :repositories, :github_id, :integer, null: true
    
    remove_index :users, :github_id
    remove_index :repositories, :github_id
  end
end
