require 'rails_helper'

describe BlacklistedUser do
  describe "validations" do
    it { expect(BlacklistedUser.new(username: "foo").save).to eq(true) }
    it { expect(BlacklistedUser.new(username: nil).save).to eq(false) }

    it "ensure uniqueness of username" do
      expect(BlacklistedUser.new(username: "foo").save).to eq(true)
      expect(BlacklistedUser.new(username: "foo").save).to eq(false)
    end
  end
end