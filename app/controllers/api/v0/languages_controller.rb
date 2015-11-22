# encoding: utf-8
module Api
  module V0
    class LanguagesController < ApiController

      def index
        languages = read_languages_from_file
        respond(languages, :ok)
      end

      private

      def read_languages_from_file
        languages_file = Rails.root.join('app/assets/json/languages.json')
        file_contents = File.read(languages_file)
        Rails.cache.fetch('languages') { JSON.parse(file_contents) }
      end

    end
  end
end
