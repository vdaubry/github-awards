module Api
  module V0
    module Documentation
      module SwaggerUsersControllerMod

        def self.included(base)
          base.class_eval do
            swagger_controller Api::V0::UsersController, 'Api::V0::UsersController'

            swagger_api :index do
              summary "Get the list of users"
              notes "Filter users by location and language"

              param :query, :language, :string, :optional, "Filter users by language"
              param :query, :city, :string, :optional, "Filter users by city"
              param :query, :country, :string, :optional, "Filter users by country"
              param :query, :page, :integer, :optional, "Return the results for the disered page. Each page returns 25 records."

              type :index_response

              response :ok
            end

            swagger_model :index_response do
              property :users,
                       :array,
                       :required,
                       "List of users",
                       {
                          "items" => {
                            "$ref" => "index_user_item"
                          }
                        }
              property :page, :integer, :required, "Page being returned"
              property :total_count, :integer, :required, "Total count of records"
              property :total_pages, :integer, :required, "Total pages"
            end

            swagger_model :index_user_item do
              property :id, :integer, :required, 'The id of the user'
              property :login, :string, :required, 'The github login name of the user'
              property :gravatar_url, :string, :required, 'The gravatar_url of the user'
              property :city, :string, :required, 'The city of the user'
              property :country, :string, :required, 'The country of the user'
              property :city_rank, :integer, :required, 'The city rank of the user'
              property :country_rank, :integer, :required, 'The country rank of the user'
              property :world_rank, :integer, :required, 'The world rank of the user'
            end

            swagger_api :show do
              summary "Get the user details"
              notes "Get the details of a user"

              param :path, 'login', :integer, :required, 'The user\'s github login.'

              type :show_response

              response :ok
              response :not_found
            end

            swagger_model :show_response do
              property :user, :user, :required, "User"
            end

            swagger_model :user do
              property :id, :integer, :required, 'The id of the user'
              property :login, :string, :required, 'The github login name of the user'
              property :gravatar_url, :string, :required, 'The gravatar_url of the user'
              property :city, :string, :required, 'The city of the user'
              property :country, :string, :required, 'The country of the user'
              property :rankings,
                       :array,
                       :required,
                       "List of rankings (one for each language)",
                       {
                          "items" => {
                            "$ref" => "user_ranking"
                          }
                        }
            end

            swagger_model :user_ranking do
              property :language, :string, :required, 'The ranking\'s language'
              property :repository_count, :string, :required, 'The ranking\'s repository_count'
              property :stars_count, :string, :required, 'The ranking\'s stars_count'
              property :city_rank, :string, :required, 'The ranking\'s city_rank'
              property :city_count, :string, :required, 'The ranking\'s city_count'
              property :country_rank, :string, :required, 'The ranking\'s country_rank'
              property :country_count, :string, :required, 'The ranking\'s country_count'
              property :world_rank, :string, :required, 'The ranking\'s world_rank'
              property :world_count, :string, :required, 'The ranking\'s world_count'
            end

          end
        end
      end
    end
  end
end
