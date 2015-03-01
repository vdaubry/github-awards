class User < ActiveRecord::Base
  has_many :language_ranks
  validates :login, presence: true, uniqueness: true
  before_save { |user| user.login.downcase! }
  
  def to_param
    login
  end
end