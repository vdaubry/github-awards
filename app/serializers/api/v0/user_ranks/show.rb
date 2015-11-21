module Api
  module V0
    module UserRanks
      class Show < ActiveModel::Serializer

        has_one :user

        def user
          UserSerializer.new(object).serializable_hash.merge(ranks_for(object))
        end

        def ranks_for(user)
          user.user_ranks
        end

      end
    end
  end
end
