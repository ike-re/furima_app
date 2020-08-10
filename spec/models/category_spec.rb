require 'rails_helper'

describe Category do
  describe "#create" do
    it "is valid with a name" do
      category = build(:category)
      expect(category).to be_valid
    end
    it "is invalid without a name" do
      category = build(:category, name: nil)
      category.valid?
      expect(category.errors[:name]).to include("を入力してください")
    end

  end
end
