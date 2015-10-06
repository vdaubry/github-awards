class CreateBlacklistedUser < ActiveRecord::Migration
  def change
    create_table :blacklisted_users do |t|
      t.string :username, null: false
      t.timestamps null: false
    end

    add_index :blacklisted_users, :username, unique: true
  end
end
