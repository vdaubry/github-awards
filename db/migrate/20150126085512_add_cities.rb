class AddCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string   :country,           null: false
      t.string   :city,              null: false
      t.string   :accented_city,     null: false
    end
    
    add_index :cities, [:city]
    add_index :cities, [:country]
  end
end
