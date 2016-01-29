require "rails_helper"

describe Api::V0::LanguagesController do

  describe 'GET#index' do
    def response_hash
      @response_body = JSON.parse(response.body)
    end

    before(:each) do
      File.stubs(:read).returns(["JavaScript","C#","Ruby"].to_json)
    end

    it "returns all languages" do
      get :index
      expect(response_hash['languages'].count).to eq(3)
    end

    context "sorting not defined" do
      it 'should return a list of languages ordered alphabetically' do
        get :index
        expect(response_hash['languages']).to eq(["C#","JavaScript","Ruby"])
      end
    end

    context "sort by popularity" do
      it 'should return a list of languages ordered by popularity' do
        get :index, sort: :popularity
        expect(response_hash['languages']).to eq(["JavaScript","C#","Ruby"])
      end
    end

    context "sort alphabetically" do
      it 'should return a list of languages ordered alphabetically' do
        get :index, sort: :alphabetical
        expect(response_hash['languages']).to eq(["C#","JavaScript","Ruby"])
      end
    end

    context "return with user count" do
      it 'should return a list of languages with users count' do
        get :index, sort: :alphabetical, with_count: true
        expect(response_hash['languages']).to eq([
          { "C#" => 0 },
          { "JavaScript" => 0 },
          { "Ruby" => 0 }
        ])
      end
    end

  end
end