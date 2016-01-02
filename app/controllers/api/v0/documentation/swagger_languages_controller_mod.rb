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

              param_list :query,
                         :sort,
                         :string,
                         :optional,
                         "Sort order (alphabetical, or popularity, defaults " \
                           " to alphabetical)",
                         ['alphabetical', 'popularity']

              type :response

              response :ok
            end

            swagger_model :response do
              property :languages,
                       :array,
                       :required,
                       "List of languages",
                       {
                          "items" => {
                            "$ref" => "string"
                          }
                        }
            end


          end
        end
      end
    end
  end
end
