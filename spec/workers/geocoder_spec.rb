require 'rails_helper'

describe GeocoderWorker do
  describe "geocode" do
    
    context "Google Map" do
      context "valid location" do
        it "returns geocoded result" do
          res = {city: "Paris", country: "France"}
          GoogleMapClient.any_instance.stubs(:geocode).with("paris").returns(res)
          GeocoderWorker.new.geocode("paris", :googlemap).should == res
        end
        
        it "catches GoogleMapRateLimitExceeded" do
          GoogleMapClient.any_instance.stubs(:geocode).with("paris").raises GoogleMapRateLimitExceeded
          GeocoderWorker.new.geocode("paris", :googlemap).should == nil
        end
      end
    end
    
    context "Open Street Map" do
      context "valid location" do
        it "returns geocoded result" do
          res = {city: "Paris", country: "France"}
          OpenStreetMapClient.any_instance.stubs(:geocode).with("paris").returns(res)
          GeocoderWorker.new.geocode("paris", :openstreetmap).should == res
        end
        
        it "catches Errors" do
          OpenStreetMapClient.any_instance.stubs(:geocode).with("paris").raises Errno::ENETDOWN
          GeocoderWorker.new.geocode("paris", :openstreetmap).should == nil
        end
      end
    end
  end
end