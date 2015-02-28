class Repository < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {scope: :user_id}
  validates :user_id, presence: true
  before_save { |repo| repo.user_id.downcase! }
end
