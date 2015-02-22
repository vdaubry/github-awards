class AddIndexOnUserLocation < ActiveRecord::Migration
  def change
    add_index :users, [:location]
  end
end
