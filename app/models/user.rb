class User < ActiveRecord::Base
  include User::Rank  
  has_many :repositories
  validates :login, presence: true, uniqueness: true
  before_save { |user| user.login.downcase! }
  
  def to_param
    login
  end
  
  def self.find_as_sorted(ids)
    if ids.length > 0
      values = []
      ids.each_with_index do |id, index|
        values << "(#{id}, #{index + 1})"
      end
      self.joins("JOIN (VALUES #{values.join(",")}) as x (id, ordering) ON #{table_name}.id = x.id").order('x.ordering').group('x.ordering')
    else
      self
    end
  end
end