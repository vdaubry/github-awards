module Languages
  class Index

    class << self

      def get(sort: :alphabetical)
        languages = Rails.cache.fetch('languages') do
          file_contents = File.read(languages_file)
          JSON.parse(file_contents).compact
        end
        sort == :alphabetical ? languages.sort : languages
      end

      def languages_file
        Rails.root.join('app/assets/json/languages.json')
      end

    end

  end
end
