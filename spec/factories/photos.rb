FactoryBot.define do
  factory :photo do
    product_id    {"1"}
    image          {Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.png'), 'spec/factories/test.png')}
    product
  end
end
