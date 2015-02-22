class OpenStreetMapClient
  def initialize(proxy_opts={})
    @proxy_opts = proxy_opts
  end
  
  def geocode(location)
    response = HTTParty.get("http://nominatim.openstreetmap.org/search?q=#{URI.encode(location)}&format=json&accept-language=en-US&addressdetails=1", @proxy_opts)
    result = JSON.parse(response.body)
    
    place = result.select {|r| ["administrative", "suburb", "residential", "city", "town", "village"].include?(r["type"]) }.first
    return {:city => place["address"]["city"], :country => place["address"]["country"]} if place
  end
end
