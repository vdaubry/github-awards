class LanguageRank < ActiveRecord::Base
  belongs_to :user
  validates :language, :score, :city_rank, :country_rank, :world_rank, :repository_count, :stars_count, presence: true
  validates :language, uniqueness: {scope: [:user_id, :city, :country]}
end
