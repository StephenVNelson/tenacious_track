require 'test_helper'
require 'pry'

class ElementTest < ActiveSupport::TestCase

  def setup
    @element = Element.create(series_name: "Body Position", name: "Not Prone")
  end

  test "should be valid" do
    assert @element.valid?
  end

  test "series name should be present" do
    @element.series_name = "       "
    assert_not @element.valid?
  end

  test "email should be present" do
    @element.name = "     "
    assert_not @element.valid?
  end

  test "series name should not be too long" do
    @element.series_name = "a"*51
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
