require 'rails_helper'

RSpec.describe Element, type: :model do

  it "has a working factory" do
    element = build(:element)
    expect(element).to be_valid
  end

  it "is invalid if duplicate #name" do
    create(:element,
      name: "Mini Band",
    )
    element = build(:element,
      name: "Mini Band",
    )
    element.valid?
    expect(element.errors[:name]).to include("has already been taken")

  end

  before(:context) do
    @category1 = create(:element_category)
    @category2 = create(:angle)
    @element1 = create(:element, name: "Supine")
    @element2 = create(:element, name: "Prone")
    @element3 = create(:element_angle, name: "Incline")
    @element4 = create(:element_angle, name: "Included")
  end
  after(:context) do
    Element.all.each {|e| e.delete}
    ElementCategory.all.each {|e| e.delete}
  end

  describe ".text_search" do

    it "returns elements that match #text_search" do
      expect(Element.text_search("inc")).to include(@element3, @element4)
      expect(Element.text_search("inc")).not_to include(@element2, @element1)
    end

    it "returns all elements if search query is empty" do
      expect(Element.text_search("")).to include(@element1, @element2, @element3, @element4)
    end
  end

  describe "names" do
    it "returns all element .names" do
      expect(Element.names).to include("Supine", "Prone", "Incline", "Included")
    end

    it "returns an element #by_name" do
      expect(Element.by_name("Supine")).to eq(@element1)
    end
  end

  describe "categories" do
    it "returns .sorted_categories" do
      expect(Element.sorted_categories).to eq([@category1,@category2])
    end

    it "returns .category_elements that belong to a specific category" do
      expect(Element.category_list).to eq([@category1.category_name,@category2.category_name])
    end

    it "returns .category_element_names that belong to a specific category" do
      expect(Element.category_element_names("Body Position")).to include(@element1.name, @element2.name)
    end

    it "returns .category_element_names_and_ids that belong to a specific category" do
      expect(Element.category_element_names_and_ids("Body Position")).to include(
        [@element1.name, @element1.id],
        [@element2.name, @element2.id])
    end

    it "returns .element_names_and_ids_grouped_by_categories" do
      expectation = [
        ["Body Position",
          [
            [@element1.name, @element1.id],
            [@element2.name, @element2.id]
          ]
        ],
        ["Angle",
          [
            [@element3.name, @element3.id],
            [@element4.name, @element4.id]
          ]
        ]
      ]
      expect(Element.element_names_and_ids_grouped_by_categories).to eq(expectation)
    end

    it "returns .element_names_grouped_by_categories" do
      expectation = [
        ["Body Position",
          [@element1.name, @element2.name]
        ],
        ["Angle",
          [@element3.name, @element4.name]
        ]
      ]
      expect(Element.element_names_grouped_by_categories).to eq(expectation)
    end
  end
end
