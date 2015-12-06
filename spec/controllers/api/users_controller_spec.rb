require "rails_helper"

describe Api::V0::UsersController, :users_api_spec do

  def response_hash
    @response_body = JSON.parse(response.body)
  end

  before(:each) do
    @vdaubry = FactoryGirl.create(:user, gravatar_url: 'url', login: 'vdaubry', city: 'paris', country: 'france')
    FactoryGirl.create(:repository, language: 'ruby', user: @vdaubry)

    @nunogoncalves = FactoryGirl.create(:user, gravatar_url: 'url', login: 'nunogoncalves', city: 'lisbon', country: 'portugal')
    FactoryGirl.create(:repository, name: 'ios app', language: 'swift', user: @nunogoncalves)
    FactoryGirl.create(:repository, name: 'macos app', language: 'swift', user: @nunogoncalves)
    FactoryGirl.create(:repository, name: 'rails', language: 'ruby', user: @nunogoncalves)

    @walterwhite = FactoryGirl.create(:user, login: 'walterwhite', city: 'albuquerque', country: 'usa')
    FactoryGirl.create(:repository, language: 'JavaScript', user: @walterwhite)

    @sherlockholmes = FactoryGirl.create(:user, login: 'sherlockholmes', city: 'san francisco', country: 'us', gravatar_url: 'url')
    FactoryGirl.create(:repository, language: 'JavaScript', user: @sherlockholmes)

    $redis.zadd("user_ruby_paris", 1.1, @vdaubry.id)
    $redis.zadd("user_swift_lisbon", 5.0, @nunogoncalves.id)
    $redis.zadd("user_JavaScript_albuquerque", 0.2, @walterwhite.id)
    $redis.zadd("user_JavaScript_san francisco", 0.5, @sherlockholmes.id)
  end

  context 'GET#index' do

    it 'should return status 200' do
      get :index
      expect(response.status).to eq(200)
    end

    context 'with scope' do
      it 'should return 1 user' do
        get :index, language: 'swift', city: 'lisbon', type: 'city'

        expect(response_hash['users'].count).to eq(1)
      end

      it 'should return propper user information' do
        get :index, language: 'swift', city: 'lisbon', type: 'city'

        first_user = response_hash['users'].first

        expect(first_user['gravatar_url']).to eq('url')
        expect(first_user['login']).to eq('nunogoncalves')
        expect(first_user['city']).to eq('lisbon')
        expect(first_user['country']).to eq('portugal')
        expect(first_user['city_rank']).to eq(1)
        expect(first_user['country_rank']).to eq(1)
        expect(first_user['world_rank']).to eq(1)
      end

    end

    context 'without scope' do
      it 'should return 1 user' do
        get :index

        expect(response_hash['users'].count).to eq(1)
      end

      it 'should return propper user information' do
        get :index

        first_user = response_hash['users'].first
        expect(first_user['gravatar_url']).to eq('url')
        expect(first_user['login']).to eq('sherlockholmes')
        expect(first_user['city']).to eq('san francisco')
        expect(first_user['country']).to eq('us')
      end
    end

    context 'pagination metadata' do
      it 'should return pagination metadata' do
        get :index, language: 'swift', city: 'lisbon', type: 'city'
        expect(response_hash['total_count']).to eq(1)
        expect(response_hash['page']).to eq(1)
        expect(response_hash['total_pages']).to eq(1)
      end
    end

    context 'search context', :testing do
      it 'should return search context (city)' do
        get :index, language: 'Swift', city: 'lisbon', type: 'city'
        expect(response_hash['language']).to eq('Swift')
        expect(response_hash['location_name']).to eq('lisbon')
        expect(response_hash['location_type']).to eq('city')
      end

      it 'should return search context (country)' do
        get :index, language: 'Swift', country: 'Portugal', type: 'country'
        expect(response_hash['language']).to eq('Swift')
        expect(response_hash['location_name']).to eq('portugal')
        expect(response_hash['location_type']).to eq('country')
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
      expect(user_rankings[0]['stars_count']).to eq(0)
      expect(user_rankings[0]['city']).to eq('lisbon')
      expect(user_rankings[0]['city_rank']).to eq(1)
      expect(user_rankings[0]['city_count']).to eq(1)
      expect(user_rankings[0]['country']).to eq('portugal')
      expect(user_rankings[0]['country_rank']).to eq(1)
      expect(user_rankings[0]['country_count']).to eq(1)
      expect(user_rankings[0]['world_rank']).to eq(1)
      expect(user_rankings[0]['world_count']).to eq(1)

      expect(user_rankings[1]['language']).to eq('ruby')
      expect(user_rankings[1]['repository_count']).to eq(1)
      expect(user_rankings[1]['stars_count']).to eq(0)
      expect(user_rankings[1]['city']).to eq('lisbon')
      expect(user_rankings[1]['city_rank']).to eq(1)
      expect(user_rankings[1]['city_count']).to eq(1)
      expect(user_rankings[1]['country']).to eq('portugal')
      expect(user_rankings[1]['country_count']).to eq(1)
      expect(user_rankings[1]['country_rank']).to eq(1)
      expect(user_rankings[1]['world_rank']).to eq(1)
      expect(user_rankings[1]['world_count']).to eq(1)

    end
  end
end