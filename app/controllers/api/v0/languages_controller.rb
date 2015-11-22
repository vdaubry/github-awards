# encoding: utf-8
module Api
  module V0
    class LanguagesController < ApiController

      def index
        languages = get_languages

        respond(languages, :ok)
      end

      private

      def get_languages
        languges_file = Rails.root.join('app/assets/json/languages.json')
        file_contents = File.read(languges_file)
        Rails.cache.fetch('languages') { JSON.parse(file_contents) }
      end

    end
  end
end
