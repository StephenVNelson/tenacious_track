require 'rails_helper'

RSpec.describe ElementCategory, type: :model do

  it "has a valid factory" do
    expect(build(:element_category)).to be_valid
  end

  it "is not valid without #category_name" do
    category = build(:element_category ,category_name: nil)
    category.valid?
    expect(category.errors[:category_name]).to include("can't be blank")
  end

  it "is not valid without #sort" do
    category = build(:element_category, sort: nil)
    category.valid?
    expect(category.errors[:sort]).to include("can't be blank")
  end

  describe "category attributes must be unique" do

    it "is not valid if #category_name is already used" do
      create( :element_category, category_name: "Movement")
      category = build( :element_category, category_name: "Movement")
      category.valid?
      expect(category.errors[:category_name]).to include("has already been taken")
    end

    it 'not valid if category sort number is already used' do
      create( :element_category, sort: 2)
      category = build( :element_category, sort: 2)
      category.valid?
      expect(category.errors[:sort]).to include("has already been taken")
    end

  end

  it "must be listed in sort order" do
    category1 = create(:element_category,
      category_name: "First",
      sort: 4
    )
    category2 = create(:element_category,
      category_name: "Second",
      sort: 5
    )
    category3 = create(:element_category,
      category_name: "Third",
      sort: 3
    )
    expect(ElementCategory.by_position).to eq([category3, category1, category2])
  end

  it "calculates the .max_position value for new categories" do
    count = ElementCategory.count
    expect(ElementCategory.max_position).to eq(count + 1)
  end
end
