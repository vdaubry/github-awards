# encoding: utf-8
require 'rails_helper'

module Api
  module V0
    class UsersController < ApiController

      def index
        @user_list = UserListPresenter.new(params)
        respond(UserRanks::Index.new(@user_list).serializable_hash, :ok)
      end

      def show
        respond({ id: 1, username: 'nunogoncalves' })
      end
    end
  end
end
