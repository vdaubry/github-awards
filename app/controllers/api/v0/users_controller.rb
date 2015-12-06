# encoding: utf-8
module Api
  module V0
    class UsersController < ApiController

      def index
        user_list_presenter = UserListPresenter.new(params)
        user_ranks = user_list_presenter.user_ranks
        respond(UserRanks::IndexSerializer.new(user_ranks).serializable_hash)
      end

      def show
        user = User.where(login: params[:login].try(:downcase).try(:strip)).first
        return respond({}, :not_found) unless user

        respond(UserRanks::ShowSerializer.new(user).serializable_hash, :ok)
      end

    end
  end
end
