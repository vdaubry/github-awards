module Api
  module V0
    module UserRanks
      class Index < ActiveModel::Serializer

        attributes :users

        def users
          object.user_ranks.map do |user|
            UserSerializer.new(user.user).serializable_hash.merge(ranks_for(user))
          end
        end

        def ranks_for(user)
          user.ranks
        end

      end
    end
  end
end
