class AddFullNameToCountry < ActiveRecord::Migration
  def change
    add_column :cities, :country_full_name, :string, :index => true
  end
end
