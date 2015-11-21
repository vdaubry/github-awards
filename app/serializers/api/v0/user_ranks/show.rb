module Api
  module V0
    module UserRanks
      class Show < ActiveModel::Serializer

        has_one :user

        def user
          h =UserSerializer.new(object).serializable_hash
          h.merge(ranks_for(object))
        end

        def ranks_for(user)
          ranks = []
          user.user_ranks.each do |rank|
            ranks << {
              language: rank.language,
              repository_count: rank.repository_count,
              stars_count: rank.stars_count,
              city: user.city,
              city_rank: rank.city_rank,
              country: user.country,
              country_rank: rank.country_rank,
              world_rank: rank.world_rank,
            }
          end
          { rankings: ranks }
        end

      end
    end
  end
end
