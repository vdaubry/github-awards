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

              response :ok
            end

            swagger_api :show do
              summary "Get the user details"
              notes "Get the details of a user"

              param :path, 'login', :integer, :required, 'The user\'s github login.'

              response :ok
              response :not_found
            end

          end
        end
      end
    end
  end
end
