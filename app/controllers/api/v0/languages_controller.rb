# encoding: utf-8
module Api
  module V0
    class LanguagesController < ApiController

      def index
        languages = Languages::Index.get
        respond(languages, :ok)
      end

    end
  end
end
