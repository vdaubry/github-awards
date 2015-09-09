class Models::GithubClient
  attr_accessor :max_list_size
  attr_accessor :on_found_object, :on_error, :on_too_many_requests
  
  def initialize(token=nil)
    @client = Octokit::Client.new(access_token: token)
    @max_list_size = 100
  end
  
  def list(method, since)
    loop do
      results = api_call(method, {since: since})
      next if results.nil?
      
      Rails.logger.info "found #{results.size} objects starting at #{since}"
      results.each do |object|
        on_found_object.call(object)
      end
      since = results.last[:id]
      break if results.size < max_list_size
    end
  end
  
  def get(method, params)
    api_call(method, params)
  end
  
  private 
  
  def api_call(method, params)
    begin
      @client.send(method, params)
    rescue Octokit::TooManyRequests => e
      on_too_many_requests.call(e) if on_too_many_requests
    rescue StandardError => e
      on_error.call(e) if on_error
    end
  end
end