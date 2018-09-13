require 'test_helper'

class ElementEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:stephen)
    @element1 = elements(:one)
  end
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_element_path(@element1)
    assert_template 'elements/edit'
    patch element_path(@element1), params: {element: {series_name: "", name: "Prone"}}
    assert_template 'elements/edit'
  end
end
