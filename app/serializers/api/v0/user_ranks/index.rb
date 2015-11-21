module Api
  module V0
    module UserRanks
      class Index < ActiveModel::Serializer

        has_many :users

        def users
          object.user_ranks.map do |user|
            Users::Index.new(user.user).serializable_hash
          end
        end

      end
    end
  end
end
