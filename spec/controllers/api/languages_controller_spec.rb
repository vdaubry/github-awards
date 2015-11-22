require "rails_helper"

describe Api::V0::LanguagesController do

  def response_hash
    @response_body = JSON.parse(response.body)
  end


  context 'GET#index' do

    it 'should return a list of languages' do
      get :index
      expect(response_hash['languages'].count).to eq(223)
      expect(response_hash['languages'][0]).to eq('JavaScript')
      expect(response_hash['languages'][12]).to eq('Swift')
      expect(response_hash['languages'][5]).to eq('Ruby')
    end

  end
end