module Languages
  class Index

    class << self

      def get
        file_contents = File.read(languages_file)
        Rails.cache.fetch('languages') { JSON.parse(file_contents) }
      end

      def languages_file
        Rails.root.join('app/assets/json/languages.json')
      end

    end

  end
end
