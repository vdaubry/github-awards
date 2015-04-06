require 'zlib'
require 'stringio'
require 'yajl'
        
class Models::Stream
  def initialize(time:)
    #Githubarchive events are available starting yesterday
    @filename = "#{time.strftime("%Y-%m-%d-%H")}.json.gz"
  end
  
  def download(filename:)
    Rails.logger.info("Downloading data.githubarchive.org/#{filename}")
    Net::HTTP.start("data.githubarchive.org") do |http|
      resp = http.get("/#{filename}")
      gz = Zlib::GzipReader.new(StringIO.new(resp.body.to_s))    
      gz.read
    end
  end
  
  def parse
    content = download(filename: @filename)
    
    Rails.logger.info("Start parsing events")
    Yajl::Parser.parse(content) do |event|
      if event["type"]=="WatchEvent"
        $redis.sadd(key, event["repo"]["name"])
      end
    end
  end
  
  def each
    loop do
      res = $redis.spop(key)
      break if res.nil?
      
      yield(res)
    end
  end
  
  def key
    "stream_repos"
  end
  
end