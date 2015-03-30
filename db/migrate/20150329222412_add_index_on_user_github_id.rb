class AddIndexOnUserGithubId < ActiveRecord::Migration
  def change
    add_index "users", "github_id", name: "index_users_on_github_id", using: :btree
  end
end