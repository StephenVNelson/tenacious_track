require 'rails_helper'

RSpec.describe ElementCategory, type: :model do
  it "is valid with valid attributes" do
    expect(ElementCategory.count).to eq(2)
    category = ElementCategory.create(category_name: "Movements", sort: 20)
    expect(ElementCategory.count).to eq(3)
    expect(category.valid?).to be true
  end
  it "is not valid without #category_name"
  it "is not valid if #category_name is already used"
  it "must have sort order"
  it "must be listed in sort order"
end
