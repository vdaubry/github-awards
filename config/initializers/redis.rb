require_relative '../../extras/extensions/redis_key'
if ENV["REDIS_URL"]
  uri = URI.parse(ENV["REDIS_URL"])
  $redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
else
  $redis = Redis.new
end