# encoding: utf-8
module Api
  module V0
    class UsersController < ApiController

      def index
        @user_list = UserListPresenter.new(params)
        respond(UserRanks::Index.new(@user_list).serializable_hash, :ok)
      end

      def search
        @user = User.where(login: params[:login].try(:downcase).try(:strip)).first
        return respond({}, :not_found) unless @user

        respond(UserRanks::Show.new(@user).serializable_hash, :ok)
      end
    end
  end
end
