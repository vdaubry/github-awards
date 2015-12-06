require "rails_helper"

describe Api::V0::LanguagesController do

  def response_hash
    @response_body = JSON.parse(response.body)
  end

  context 'GET#index' do
    it 'should return a list of languages' do

      mocked_languages = { 'languages' => ['JavaScript', 'Swift', 'Ruby'] }
      JSON.stubs(:parse).returns(mocked_languages)

      get :index

      expect(response_hash['languages'].count).to eq(3)
      expect(response_hash['languages'][0]).to eq('JavaScript')
      expect(response_hash['languages'][1]).to eq('Swift')
      expect(response_hash['languages'][2]).to eq('Ruby')
    end

  end
end