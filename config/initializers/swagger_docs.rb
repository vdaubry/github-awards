API = "docs"
Swagger::Docs::Config.register_apis({
  "0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => "public/#{API}",
    # the URL base path to your API
    :base_path => "http://#{ENV['HOST']}/",
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "Github Awards Api",
        "description" => "The Github Awards api description.",
        "termsOfServiceUrl" => "http://helloreverb.com/terms/",
        "contact" => "numicago@gmail.com",
        "license" => "Apache 2.0",
        "licenseUrl" => "http://www.apache.org/licenses/LICENSE-2.0.html"
      }
    }
  }
})

class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    "/#{API}/#{path}"
  end
end