module Api
  module V0
    module UserRanks
      class IndexSerializer < ActiveModel::Serializer

        attributes :users, :page, :total_pages, :total_count

        def users
          object.map do |rank|
            UserSerializer.new(rank.user).serializable_hash.merge(ranks_for(rank))
          end
        end

        def ranks_for(rank)
          {
            stars_count: rank.stars_count,
            city_rank: rank.city_rank,
            country_rank: rank.country_rank,
            world_rank: rank.world_rank
          }
        end

        def total_pages
          object.total_pages
        end

        def page
          object.current_page
        end

        def  total_count
          object.total_count
        end

      end
    end
  end
end
