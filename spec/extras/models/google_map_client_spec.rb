require 'rails_helper'

describe GoogleMapClient do
  
  let(:valid_response) { {"results"=>[{"address_components"=>[{"long_name"=>"New York", "short_name"=>"NY", "types"=>["locality", "political"]}, {"long_name"=>"Kings County", "short_name"=>"Kings County", "types"=>["administrative_area_level_2", "political"]}, {"long_name"=>"New York", "short_name"=>"NY", "types"=>["administrative_area_level_1", "political"]}, {"long_name"=>"United States", "short_name"=>"US", "types"=>["country", "political"]}], "formatted_address"=>"New York, NY, USA", "geometry"=>{"bounds"=>{"northeast"=>{"lat"=>40.91525559999999, "lng"=>-73.70027209999999}, "southwest"=>{"lat"=>40.4913699, "lng"=>-74.25908989999999}}, "location"=>{"lat"=>40.7127837, "lng"=>-74.0059413}, "location_type"=>"APPROXIMATE", "viewport"=>{"northeast"=>{"lat"=>40.91525559999999, "lng"=>-73.70027209999999}, "southwest"=>{"lat"=>40.4913699, "lng"=>-74.25908989999999}}}, "types"=>["locality", "political"]}, {"address_components"=>[{"long_name"=>"New York", "short_name"=>"New York", "types"=>["locality", "political"]}, {"long_name"=>"Union", "short_name"=>"Union", "types"=>["administrative_area_level_3", "political"]}, {"long_name"=>"Wayne County", "short_name"=>"Wayne County", "types"=>["administrative_area_level_2", "political"]}, {"long_name"=>"Iowa", "short_name"=>"IA", "types"=>["administrative_area_level_1", "political"]}, {"long_name"=>"United States", "short_name"=>"US", "types"=>["country", "political"]}, {"long_name"=>"50238", "short_name"=>"50238", "types"=>["postal_code"]}], "formatted_address"=>"New York, IA 50238, USA", "geometry"=>{"location"=>{"lat"=>40.8516701, "lng"=>-93.25993179999999}, "location_type"=>"APPROXIMATE", "viewport"=>{"northeast"=>{"lat"=>40.8530190802915, "lng"=>-93.25858281970848}, "southwest"=>{"lat"=>40.8503211197085, "lng"=>-93.2612807802915}}}, "types"=>["locality", "political"]}], "status"=>"OK"} }
  let(:invalid_response) { {"results"=>[]} }
  let(:country_only) { {"results"=>[{"address_components"=>[{"long_name"=>"France", "short_name"=>"FR", "types"=>["country", "political"]}], "formatted_address"=>"France", "geometry"=>{"bounds"=>{"northeast"=>{"lat"=>51.089166, "lng"=>9.560067799999999}, "southwest"=>{"lat"=>41.3423276, "lng"=>-5.141227900000001}}, "location"=>{"lat"=>46.227638, "lng"=>2.213749}, "location_type"=>"APPROXIMATE", "viewport"=>{"northeast"=>{"lat"=>51.089166, "lng"=>8.2335491}, "southwest"=>{"lat"=>42.333014, "lng"=>-4.795341899999999}}}, "types"=>["country", "political"]}], "status"=>"OK"} }
  let(:rate_limit) { {"status" => "OVER_QUERY_LIMIT"} }
  let(:client) { GoogleMapClient.new }
  
  describe "geocode" do
    context "valid location" do
      it "returns city and country" do
        HTTParty.stubs(:get).returns(stub(body: valid_response.to_json))
        client.geocode("New York").should == {city: "New York", country: "United States"}
      end
    end
    
    context "invalid location" do
      it "returns nil" do
        HTTParty.stubs(:get).returns(stub(body: invalid_response.to_json))
        client.geocode("New York").should == nil
      end
    end
    
    context "cannot find city" do
      it "return only country" do
        HTTParty.stubs(:get).returns(stub(body: country_only.to_json))
        client.geocode("France").should == {city: nil, country: "France"}
      end
    end
    
    
    context "raises GoogleMapRateLimitExceeded" do
      it "returns city and country" do
        HTTParty.stubs(:get).returns(stub(body: rate_limit.to_json))
        expect {
          client.geocode("New York")
        }.to raise_error GoogleMapRateLimitExceeded
      end
    end
  end
end