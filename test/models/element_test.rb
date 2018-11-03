require 'test_helper'
require 'pry'

class ElementTest < ActiveSupport::TestCase

  def setup
    @category1 = element_categories(:one)
    @element = Element.create(element_category: @category1, name: "Not Prone")
  end

  test "should be valid" do
    assert @element.valid?
  end

  test "category should be present" do
    @element.element_category = nil
    assert_not @element.valid?
  end

  test "name should be present" do
    @element.name = "     "
    assert_not @element.valid?
  end

  test "name should not be too long" do
    @element.name = "a"*51 + "@example.com"
    assert_not @element.valid?
  end
  
  test "element name should be unique" do
    element2 = Element.new(@element.attributes)
    assert_not element2.valid?
  end

end
