class IndexRepoUserId < ActiveRecord::Migration
  def change
    add_index "repositories", ["user_login"], name: "index_repositories_on_user_login", using: :btree    
    add_index "repositories", ["user_id", "language", "stars"], name: "index_repositories_on_user_id_and_language_and_stars", using: :btree
  end
end