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

      it 'should return a list of languages ordered alphabetically with count false' do
        get :index, sort: :alphabetical, with_count: false
        expect(response_hash['languages']).to eq(["C#","JavaScript","Ruby"])
      end
    end

    context "return with user count" do

      before(:each) do
        @vdaubry = FactoryGirl.create(:user, gravatar_url: 'url', login: 'vdaubry', city: 'paris', country: 'france')
        FactoryGirl.create(:repository, language: 'ruby', user: @vdaubry)

        @nunogoncalves = FactoryGirl.create(:user, gravatar_url: 'url', login: 'nunogoncalves', city: 'lisbon', country: 'portugal')
        FactoryGirl.create(:repository, name: 'rails', language: 'ruby', user: @nunogoncalves, stars: 3)

        @walterwhite = FactoryGirl.create(:user, login: 'walterwhite', city: 'albuquerque', country: 'usa')
        FactoryGirl.create(:repository, language: 'JavaScript', user: @walterwhite, stars: 4)

        @sherlockholmes = FactoryGirl.create(:user, login: 'sherlockholmes', city: 'san francisco', country: 'us', gravatar_url: 'url')
        FactoryGirl.create(:repository, language: 'C#', user: @sherlockholmes, stars: 5)


        $redis.zadd("user_ruby_paris", 1.1, @vdaubry.id)
        $redis.zadd("user_ruby", 1.1, @vdaubry.id)
        $redis.zadd("user_ruby_lisbon", 1.2, @nunogoncalves.id)
        $redis.zadd("user_ruby", 1.2, @nunogoncalves.id)
        $redis.zadd("user_javascript_albuquerque", 0.2, @walterwhite.id)
        $redis.zadd("user_javascript", 0.2, @walterwhite.id)
        $redis.zadd("user_javascript_san_francisco", 0.5, @sherlockholmes.id)
        $redis.zadd("user_c#", 0.5, @sherlockholmes.id)
      end

      let :languages_objects do
        [{
          "name" => "C#",
          "users_count" => 1
        }, {
          "name" => "JavaScript",
          "users_count" => 1
        }, {
          "name" => "Ruby",
          "users_count" => 2
        }]
      end

      it 'should return a list of languages with users count' do
        get :index, sort: :alphabetical, with_count: true
        expect(response_hash['languages']).to eq(languages_objects)
      end

      it 'should return a list of languages with users count' do
        get :index, sort: :alphabetical, with_count: "true"
        expect(response_hash['languages']).to eq(languages_objects)
      end


      it 'should return a list of languages with users count' do
        get :index, sort: :alphabetical, with_count: "some_string_value"
        expect(response_hash['languages']).to eq(["C#","JavaScript","Ruby"])
      end
    end

  end
end