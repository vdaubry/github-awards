class AddProcessedColumns < ActiveRecord::Migration
  def change
    add_column :repositories, :processed, :boolean, null: false, default: false
    add_column :users, :processed, :boolean, null: false, default: false
    
    add_index :repositories, :processed
    add_index :users, :processed
  end
end
