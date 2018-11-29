require 'rails_helper'

RSpec.describe ElementCategory, type: :model do

  it "is valid with category name and sort number" do
    category = ElementCategory.new(
                                  category_name: "Movements",
                                  sort: 20)
    expect(category).to be_valid
  end

  it "is not valid without #category_name" do
    category = ElementCategory.new(
                                  category_name: nil,
                                  sort: 20)
    category.valid?
    expect(category.errors[:category_name]).to include("can't be blank")
  end

  it "must have sort order" do
    category = ElementCategory.new(
                                      category_name: "Movement",
                                      sort: nil
    )
    category.valid?
    expect(category.errors[:sort]).to include("can't be blank")
  end

  describe "category attributes must be unique" do
    before(:example) do
      ElementCategory.create(
                                        category_name: "Movement",
                                        sort: 1
      )
    end

    it "is not valid if #category_name is already used" do
      category = ElementCategory.new(
                                        category_name: "Movement",
                                        sort: 2
      )
      category.valid?
      expect(category.errors[:category_name]).to include("has already been taken")
    end

    it 'not valid if category sort number is already used' do
      category = ElementCategory.new(
                                        category_name: "Tool",
                                        sort: 1
      )
      category.valid?
      expect(category.errors[:sort]).to include("has already been taken")
    end

  end

  it "must be listed in sort order" do
    category1 = ElementCategory.create(
      category_name: "First",
      sort: 4
    )
    category2 = ElementCategory.create(
      category_name: "Second",
      sort: 5
    )
    category3 = ElementCategory.create(
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
