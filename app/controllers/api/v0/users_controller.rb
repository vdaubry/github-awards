# encoding: utf-8
module Api
  module V0
    class UsersController < ApiController

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
        summary "She the user details"
        notes "Get the details of a user"

        param :path, 'login', :integer, :required, 'The user\'s github login.'

        response :ok
        response :not_found
      end

      def index
        user_list_presenter = UserListPresenter.new(params)
        user_ranks = user_list_presenter.user_ranks
        response = UserRanks::IndexSerializer.new(user_ranks).serializable_hash
        respond(response.merge(filter_context(user_list_presenter)), :ok)
      end

      def show
        user = User.where(login: params[:login].try(:downcase).try(:strip)).first
        return respond({}, :not_found) unless user

        respond(UserRanks::ShowSerializer.new(user).serializable_hash, :ok)
      end

      private

      def filter_context(user_list_presenter)
        {
          location_type: user_list_presenter.type,
          location_name: user_list_presenter.location,
          language: user_list_presenter.language
        }
      end

    end
  end
end
