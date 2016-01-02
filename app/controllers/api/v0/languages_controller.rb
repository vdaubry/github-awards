# encoding: utf-8
module Api
  module V0
    class LanguagesController < ApiController
      include Documentation::SwaggerLanguagesControllerMod

      def index
        sort = params["sort"].try(:to_sym) || :alphabetical
        languages = Languages::Index.get(sort: sort)
        respond({languages: languages}, :ok)
      end

    end
  end
end
