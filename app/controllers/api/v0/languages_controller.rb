# encoding: utf-8
module Api
  module V0
    class LanguagesController < ApiController

      swagger_controller Api::V0::LanguagesController, 'Api::V0::LanguagesController'

      swagger_api :index do
        summary "Get the list of languages."
        notes "You can choose between an alphabetical order or by popularity."

        param :query, :sort, :string, :optional, "Sort order. (alphabetical or popularity)"

        response :ok
      end

      def index
        sort = params["sort"].try(:to_sym) || :alphabetical
        languages = Languages::Index.get(sort: sort)
        respond(languages, :ok)
      end

    end
  end
end
