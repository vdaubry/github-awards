class GeocoderWorker
  include Sidekiq::Worker
  
  def perform(location, geocoder, proxy_opts={})
    Rails.logger.info "Geocoding #{location}"
    return if location.nil?
    
    result = geocode(location, geocoder.to_sym, proxy_opts)
    
    if result
      User.where("location = '#{location.gsub("'", "''")}'").update_all(city: result[:city].try(:downcase), country: result[:country].try(:downcase), processed: true)
      Rails.logger.info "updating users with location #{location} to city : #{result[:city]} , country : #{result[:country]}"
    else
      $redis.sadd("location_error", location)
      Rails.logger.error "No city found for #{location}"
    end
  end
  
  def geocode(location, geocoder, proxy_opts=nil)
    begin
      geocoder_client = (geocoder == :googlemap) ? GoogleMapClient.new(proxy_opts) : OpenStreetMapClient.new(proxy_opts)
      geocoder_client.geocode(location)
    rescue GoogleMapRateLimitExceeded => e
      Rails.logger.error e
      sleep 1
      nil
    rescue StandardError => e
      Rails.logger.error e
      nil
    end
  end
end