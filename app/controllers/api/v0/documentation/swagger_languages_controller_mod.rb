module Api
  module V0
    module Documentation
      module SwaggerLanguagesControllerMod

        def self.included(base)
          base.class_eval do
            swagger_controller Api::V0::LanguagesController,
                               'Api::V0::LanguagesController'

            swagger_api :index do
              summary "Get the list of languages."
              notes "You can choose between an alphabetical order or by " \
                    "popularity."

              param :query,
                    :sort,
                    :string,
                    :optional,
                    "Sort order. (alphabetical or popularity)"
              response :ok
            end
          end
        end
      end
    end
  end
end
