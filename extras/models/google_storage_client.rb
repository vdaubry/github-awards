require 'google/api_client'
require 'highline/import'
require_relative 'extras/utils/oauth_util.rb'

API_VERSION = 'v1'

class GoogleStorageClient
  def initialize(bucket = 'githubawards')
    @bucket = bucket
    @client = Google::APIClient.new(:application_name => "githubawards", :application_version => "0.1")
    @storage = @client.discovered_api('storage', API_VERSION)

    # OAuth authentication.
    auth_util = CommandLineOAuthHelper.new(
      'https://www.googleapis.com/auth/devstorage.full_control')
    @client.authorization = auth_util.authorize()
  end
  
  def download(filename)
    result = @client.execute(
      :api_method => @storage.buckets.get,
      :parameters => { 'bucket' => @bucket, 'object' => filename }
    )

    url = URI("http://storage.googleapis.com/#{@bucket}/#{filename}")
    access_token = "Bearer "+result.request.authorization.access_token

    Net::HTTP.start(url.host, url.port) do |http|
      request = Net::HTTP::Get.new url.request_uri
      request.add_field("Authorization", access_token)

      http.request request do |response|
        open filename, 'w' do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end
  end
end