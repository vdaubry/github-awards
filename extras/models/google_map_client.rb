class GoogleMapRateLimitExceeded < StandardError 
end

class GoogleMapClient
  def initialize(proxy_opts=nil)
    @proxy_opts = proxy_opts || {}
  end
  
  def geocode(location)
    response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(location)}", @proxy_opts)
    result = JSON.parse(response.body)
    
    raise GoogleMapRateLimitExceeded if result["status"]=="OVER_QUERY_LIMIT"
      
    address_components = result.try(:[], "results").try(:first).try(:[], "address_components")
    return if address_components.nil?
      
    city = address_components.select { |r| r["types"].include?("locality")}.first.try(:[], "long_name")
    country = address_components.select { |r| r["types"].include?("country")}.first.try(:[], "long_name")
    return {city: city, country: country} if city || country
  end
end
