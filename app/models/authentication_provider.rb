class AuthenticationProvider < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, :uid, :provider, :token, presence: true
  validates :uid, uniqueness: true
end
