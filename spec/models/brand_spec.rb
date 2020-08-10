require 'rails_helper'
describe Brand do
  describe "#create" do
    it "is valid with a name" do
      brand = build(:brand)
      expect(brand).to be_valid
    end
    it "is invalid without a name" do
      brand = build(:brand, name: "")
      brand.valid?
      expect(brand.errors[:name]).to include( "を入力してください" )
    end
  end
end