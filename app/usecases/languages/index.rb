module Languages
  class Index

    class << self

      attr_accessor :languages

      def get(context)
        read_languages
        languages.sort! if context[:sort] == :alphabetical
        add_users_count if ["true", true].include?(context[:with_count])
        languages
      end

      private

      def read_languages
        @languages = Rails.cache.fetch('languages') do
          file_contents = File.read(languages_file)
          JSON.parse(file_contents).compact
        end
      end

      def add_users_count
        languages.map! { |l| { "name" => "#{l}", "users_count" => users_for_language(l) } }
      end

      def languages_file
        Rails.root.join('app/assets/json/languages.json')
      end

      def users_for_language(language)
        $redis.zcard("user_#{language}".redis_key)
      end

    end

  end
end
