class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string    :name,      null: false
      t.integer   :user_id,   null: false
      t.integer   :stars,     null: false, default: 0
      t.string    :language
      t.string    :organization
      t.timestamps null: false
    end
    
    add_index :repositories, [:user_id, :language, :stars]
    add_index :repositories, [:user_id, :stars]
  end
end
