require 'rails_helper'

describe "UserListPresenter" do
  
  let(:presenter) { UserListPresenter.new(city: "Paris") }
  
  describe "new" do
    it { expect(UserListPresenter.new(city: "Paris").location).to eq("paris") }
    it { expect(UserListPresenter.new("city" => "Paris").location).to eq("paris") }
    it { expect(UserListPresenter.new(city: "Paris").type).to eq(:city) }

    it { expect(UserListPresenter.new(country: "France").location).to eq("france") }
    it { expect(UserListPresenter.new("country" => "France").location).to eq("france") }
    it { expect(UserListPresenter.new(country: "France").type).to eq(:country) }

    it { expect(UserListPresenter.new({}).location).to be nil }
    it { expect(UserListPresenter.new({}).type).to eq(:world) }

    it "sets default language" do
      expect(UserListPresenter.new({}).language).to eq("JavaScript")
    end

    context "location provided" do
      it "location trim whitespace" do
        expect(UserListPresenter.new(city: " paris ").location).to eq("paris")
      end
    end
  end
  
  describe "languages" do
    it { expect(presenter.languages.count).to eq(228) }
    it { expect(presenter.languages.first(3)).to eq(["JavaScript","Java","Ruby"]) }
  end
  
  describe "title" do
    it { expect(UserListPresenter.new(city: "paris").title).to eq("in Paris") }
    it { expect(UserListPresenter.new(country: "france").title).to eq("in France") }
    it { expect(UserListPresenter.new({}).title).to eq("worldwide") }
  end
  
  describe "show_location_input" do
    it { expect(UserListPresenter.new(city: "paris").show_location_input?).to eq(true) }
    it { expect(UserListPresenter.new({}).show_location_input?).to eq(false) }
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
        
        presenter = UserListPresenter.new(city: "paris", language: "ruby")
        
        expect(presenter.user_ranks[0].user.id).to eq(u2.id)
        expect(presenter.user_ranks[1].user.id).to eq(u3.id)
        expect(presenter.user_ranks[2].user.id).to eq(u1.id)
      end
    end
    
    context "has no result" do
      it "returns empty" do
        presenter = UserListPresenter.new(city: "paris", language: "ruby")
        expect(presenter.user_ranks).to eq([])
      end
    end
  end
end