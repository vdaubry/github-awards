module Languages
  class Index

    class << self

      def get(sort: :alphabetical)
        file_contents = File.read(languages_file)
        languages = Rails.cache.fetch('languages') { JSON.parse(file_contents).compact }
        sort == :alphabetical ? languages.sort : languages
      end

      def languages_file
        Rails.root.join('app/assets/json/languages.json')
      end

    end

  end
end
