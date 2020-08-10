require 'rails_helper'

describe Photo do
  describe "#create" do
    # let(:image_path) { Rails.root.join('spec/factories/test.png') }
    # let(:image) { Rack::Test::UploadedFile.new(image_path) }
    it "is valid with photo" do
      photo = build(:photo)
      expect(photo).to be_valid
    end

    it "is valid with 2 photos" do
      category = create(:category)
      product = create(:product)
      photo_one = create(:photo)
      photo_two = build(:photo)
      expect(photo_two).to be_valid
    end

    it "is invalid without a product_id" do
      photo = build(:photo, product_id: nil)
      photo.valid?
      expect(photo.errors[:product]).to include("を入力してください")
    end
  
    it "is invalid without image" do
      photo = build(:photo, image: nil)
      photo.valid?
      expect(photo.errors[:image]).to include("を入力してください")
    end
  end

  describe '#update' do
    it 'is valid with photo' do
      category = create(:category)
      product = create(:product)
      photo = build(:photo, product_id: product.id)
      expect(photo).to be_valid
    end
  end
end