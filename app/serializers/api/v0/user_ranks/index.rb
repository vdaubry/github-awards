module Api
  module V0
    module UserRanks
      class Index < ActiveModel::Serializer

        attributes :users

        def users
          object.user_ranks.map do |rank|
            UserSerializer.new(rank.user).serializable_hash.merge(ranks_for(rank))
          end
        end

        def ranks_for(rank)
          {
            city_rank: rank.city_rank,
            country_rank: rank.country_rank,
            world_rank: rank.world_rank
          }
        end

      end
    end
  end
end
