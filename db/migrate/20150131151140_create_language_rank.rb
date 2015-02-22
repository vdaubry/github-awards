class CreateLanguageRank < ActiveRecord::Migration
  def change
    create_table :language_ranks do |t|
      t.integer   :user_id,               null: false
      t.string    :language,              null: false
      t.float     :score,                 null: false
      t.integer   :city_rank,             null: false, default: 0
      t.integer   :country_rank,          null: false, default: 0
      t.integer   :world_rank,            null: false, default: 0
      t.string    :city
      t.string    :country
      t.integer   :repository_count,      null: false, default: 0
      t.integer   :stars_count,           null: false, default: 0
      t.integer   :city_user_count,       null: false, default: 0
      t.integer   :country_user_count,    null: false, default: 0
      t.integer   :world_user_count,      null: false, default: 0
    end
    
    add_index :language_ranks, [:user_id], name: 'language_ranks_user_id'
    add_index :language_ranks, [:language, :city_rank, :city], name: 'language_ranks_city'
    add_index :language_ranks, [:language, :country_rank, :city], name: 'language_ranks_country'
    add_index :language_ranks, [:language, :world_rank, :city], name: 'language_ranks_world'
  end
end
