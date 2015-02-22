class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :mail
      t.string  :login,         null: false
      t.string  :name
      t.string  :company
      t.string  :blog
      t.string  :gravatar_url
      t.string  :location
      t.string  :country
      t.string  :city
      t.timestamps              null: false
    end
    
    add_index :users, :login
    add_index :users, :country
    add_index :users, :city
  end
end
