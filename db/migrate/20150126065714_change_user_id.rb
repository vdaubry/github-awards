class ChangeUserId < ActiveRecord::Migration
  def change
    change_column :repositories, :user_id, :string
  end
end
