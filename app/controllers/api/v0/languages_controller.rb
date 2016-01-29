# encoding: utf-8
module Api
  module V0
    class LanguagesController < ApiController
      include Documentation::SwaggerLanguagesControllerMod

      def index
        sort = params["sort"].try(:to_sym) || :alphabetical
        with_count = params["with_count"] || false
        languages = Languages::Index.get({ sort: sort, with_count: with_count })
        respond({ languages: languages }, :ok)
      end

    end
  end
end
