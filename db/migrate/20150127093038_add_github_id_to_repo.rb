class AddGithubIdToRepo < ActiveRecord::Migration
  def change
    add_column :repositories, :github_id, :integer, null: false
    
    add_index :repositories, :github_id
  end
end
