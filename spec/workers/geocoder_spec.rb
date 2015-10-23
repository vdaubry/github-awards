require 'rails_helper'

describe GeocoderWorker do
  describe "geocode" do
    
    context "Google Map" do
      context "valid location" do
        it "returns geocoded result" do
          res = {city: "Paris", country: "France"}
          GoogleMapClient.any_instance.stubs(:geocode).with("paris").returns(res)
          expect(GeocoderWorker.new.geocode("paris", :googlemap)).to eq(res)
        end
        
        it "catches GoogleMapRateLimitExceeded" do
          GoogleMapClient.any_instance.stubs(:geocode).with("paris").raises GoogleMapRateLimitExceeded
          expect(GeocoderWorker.new.geocode("paris", :googlemap)).to eq(nil)
        end
      end
    end
    
    context "Open Street Map" do
      context "valid location" do
        it "returns geocoded result" do
          res = {city: "Paris", country: "France"}
          OpenStreetMapClient.any_instance.stubs(:geocode).with("paris").returns(res)
          expect(GeocoderWorker.new.geocode("paris", :openstreetmap)).to eq(res)
        end
        
        it "catches Errors" do
          OpenStreetMapClient.any_instance.stubs(:geocode).with("paris").raises Errno::ENETDOWN
          expect(GeocoderWorker.new.geocode("paris", :openstreetmap)).to eq(nil)
        end
      end
    end
  end
end