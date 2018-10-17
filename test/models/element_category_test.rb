require 'test_helper'

class ElementCategoryTest < ActiveSupport::TestCase
  def setup
    @category = ElementCategory.new(category_name: "Example", sort: 1)
  end

  test "should be valid" do
    assert @category.valid?
  end

  test "Category name should be present" do
    @category.category_name = "          "
    assert_not @category.valid?
  end

  test "Category name should be less than 50" do
    @category.category_name = 'a'*51
    assert_not @category.valid?
  end

  test "Should be unique" do
    duplicate_category = @category.dup
    @category.save
    assert_not duplicate_category.valid?
  end
end
