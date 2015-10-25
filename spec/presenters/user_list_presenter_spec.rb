require 'rails_helper'

describe "UserListPresenter" do
  
  let(:presenter) { UserListPresenter.new(type: :city) }
  
  describe "new" do
    context "empty location" do
      it "sets default city" do
        expect(UserListPresenter.new(type: :city).location).to eq("san francisco")
      end
      
      it "sets default country" do
        expect(UserListPresenter.new(type: :country).location).to eq("united states")
      end
      
      it "sets default language" do
        expect(presenter.language).to eq("JavaScript")
      end
    end

    context "location provided" do
      it "location trim whitespace" do
        expect(UserListPresenter.new(type: :city, city: " paris ").location).to eq("paris")
      end
    end
  end
  
  describe "languages" do
    it { expect(presenter.languages.count).to eq(223) }
  end
  
  describe "title" do
    it { expect(UserListPresenter.new(type: :city, city: "paris").title).to eq("in Paris") }
    it { expect(UserListPresenter.new(type: :world).title).to eq("worldwide") }
    
    context "invalid params" do
      it "returns default location" do
        expect(UserListPresenter.new(type: "jp", language: "CSS").title).to eq("in San francisco")
      end
    end
    
    context "missing params" do
      it "returns default location" do
        expect(UserListPresenter.new(type: "city").title).to eq("in San francisco")
      end
    end
  end
  
  describe "show_location_input" do
    it { expect(UserListPresenter.new(type: :city).show_location_input?).to eq(true) }
    it { expect(UserListPresenter.new(type: :world).show_location_input?).to eq(false) }
  end
  
  describe "user_ranks" do
    context "has results" do
      it "returns top users for this city and language ordered by city rank" do
        u1 = FactoryGirl.create(:user)
        u2 = FactoryGirl.create(:user)
        u3 = FactoryGirl.create(:user)
        r1 = FactoryGirl.create(:repository, user: u1, language: "ruby")
        r2 = FactoryGirl.create(:repository, user: u2, language: "ruby")
        r3 = FactoryGirl.create(:repository, user: u3, language: "ruby")
        
        $redis.zadd("user_ruby_paris", 1.1, u1.id)
        $redis.zadd("user_ruby_paris", 3.2, u2.id)
        $redis.zadd("user_ruby_paris", 2.2, u3.id)
        
        presenter = UserListPresenter.new(type: :city, city: "paris", language: "ruby") 
        
        expect(presenter.user_ranks[0].user.id).to eq(u2.id)
        expect(presenter.user_ranks[1].user.id).to eq(u3.id)
        expect(presenter.user_ranks[2].user.id).to eq(u1.id)
      end
    end
    
    context "has no result" do
      it "returns empty" do
        presenter = UserListPresenter.new(type: :city, city: "paris", language: "ruby") 
        expect(presenter.user_ranks).to eq([])
      end
    end
  end
end