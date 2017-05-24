require "rails_helper"

describe Api::V0::UsersController, :users_api_spec do

  def response_hash
    @response_body = JSON.parse(response.body)
  end

  before(:each) do
    @vdaubry = FactoryGirl.create(:user, gravatar_url: 'url', login: 'vdaubry', city: 'paris', country: 'france')
    FactoryGirl.create(:repository, language: 'ruby', user: @vdaubry)

    @nunogoncalves = FactoryGirl.create(:user, gravatar_url: 'url', login: 'nunogoncalves', city: 'lisbon', country: 'portugal')
    FactoryGirl.create(:repository, name: 'ios app', language: 'swift', user: @nunogoncalves, stars: 2)
    FactoryGirl.create(:repository, name: 'macos app', language: 'swift', user: @nunogoncalves, stars: 2)
    FactoryGirl.create(:repository, name: 'rails', language: 'ruby', user: @nunogoncalves, stars: 3)

    @walterwhite = FactoryGirl.create(:user, login: 'walterwhite', city: 'albuquerque', country: 'usa')
    FactoryGirl.create(:repository, language: 'javascript', user: @walterwhite, stars: 4)

    @sherlockholmes = FactoryGirl.create(:user, login: 'sherlockholmes', city: 'san francisco', country: 'us', gravatar_url: 'url')
    FactoryGirl.create(:repository, language: 'javascript', user: @sherlockholmes, stars: 5)

    @bb8 = FactoryGirl.create(:user, login: 'bb8', city: 'Los Angeles', country: 'us', gravatar_url: 'url')
    FactoryGirl.create(:repository, language: 'c++', user: @bb8, stars: 5)


    $redis.zadd("user_ruby_paris", 1.1, @vdaubry.id)
    $redis.zadd("user_ruby", 1.1, @vdaubry.id)
    $redis.zadd("user_swift_lisbon", 5.0, @nunogoncalves.id)
    $redis.zadd("user_swift", 5.0, @nunogoncalves.id)
    $redis.zadd("user_javascript_albuquerque", 0.2, @walterwhite.id)
    $redis.zadd("user_javascript", 0.2, @walterwhite.id)
    $redis.zadd("user_javascript_san_francisco", 0.5, @sherlockholmes.id)
    $redis.zadd("user_javascript", 0.5, @sherlockholmes.id)
    $redis.zadd("user_c++_los_angeles", 0.7, @bb8.id)
    $redis.zadd("user_c++", 0.7, @bb8.id)
  end

  context 'GET#index' do

    it 'should return status 200' do
      get :index
      expect(response.status).to eq(200)
    end

    context 'with scope' do
      it 'should return 1 user' do
        get :index, language: 'swift', city: 'lisbon'

        expect(response_hash['users'].count).to eq(1)
      end

      it 'should return propper user information' do
        get :index, language: 'swift', city: 'lisbon'

        first_user = response_hash['users'].first
        expect(first_user['gravatar_url']).to eq('url')
        expect(first_user['login']).to eq('nunogoncalves')
        expect(first_user['city']).to eq('lisbon')
        expect(first_user['country']).to eq('portugal')
        expect(first_user['city_rank']).to eq(1)
        expect(first_user['country_rank']).to eq(1)
        expect(first_user['world_rank']).to eq(1)
        expect(first_user['stars_count']).to eq(4)
      end

      it 'should return c++ users when request has url encoded plus sign' do
        get :index, language: "c%2B%2B", city: 'los angeles'

        first_user = response_hash['users'].first
        expect(first_user['login']).to eq('bb8')
      end
    end

    context 'without scope' do
      it 'should return 1 user' do
        get :index

        expect(response_hash['users'].count).to eq(2)
      end

      it 'should return propper user information' do
        get :index

        first_user = response_hash['users'].first
        expect(first_user['gravatar_url']).to eq('url')
        expect(first_user['login']).to eq('sherlockholmes')
        expect(first_user['city']).to eq('san francisco')
        expect(first_user['country']).to eq('us')
        expect(first_user['stars_count']).to eq(5)
      end
    end

    context 'pagination metadata' do
      it 'should return pagination metadata' do
        get :index, language: 'swift', city: 'lisbon'
        expect(response_hash['total_count']).to eq(1)
        expect(response_hash['page']).to eq(1)
        expect(response_hash['total_pages']).to eq(1)
      end
    end
  end

  context 'GET#show' do
    it 'should return status 200' do
      get :show, login: 'nunogoncalves'
      first_user = response_hash

      expect(response.status).to eq(200)
    end

    it 'should return proper user information' do
      get :show, login: 'nunogoncalves'

      user = response_hash['user']

      expect(user['gravatar_url']).to eq('url')
      expect(user['login']).to eq('nunogoncalves')
      expect(user['city']).to eq('lisbon')
      expect(user['country']).to eq('portugal')
    end

    it 'should return propper ranking information', :t do
      get :show, login: 'nunogoncalves'
      user_rankings = response_hash['user']['rankings']

      expect(user_rankings.length).to be(2)

      expect(user_rankings[0]['language']).to eq('swift')
      expect(user_rankings[0]['repository_count']).to eq(2)
      expect(user_rankings[0]['stars_count']).to eq(4)
      expect(user_rankings[0]['city_rank']).to eq(1)
      expect(user_rankings[0]['city_count']).to eq(1)
      expect(user_rankings[0]['country_rank']).to eq(1)
      expect(user_rankings[0]['country_count']).to eq(1)
      expect(user_rankings[0]['world_rank']).to eq(1)
      expect(user_rankings[0]['world_count']).to eq(1)

      expect(user_rankings[1]['language']).to eq('ruby')
      expect(user_rankings[1]['repository_count']).to eq(1)
      expect(user_rankings[1]['stars_count']).to eq(3)
      expect(user_rankings[1]['city_rank']).to eq(1)
      expect(user_rankings[1]['city_count']).to eq(1)
      expect(user_rankings[1]['country_count']).to eq(1)
      expect(user_rankings[1]['country_rank']).to eq(1)
      expect(user_rankings[1]['world_rank']).to eq(1)
      expect(user_rankings[1]['world_count']).to eq(2)

    end
  end
end
