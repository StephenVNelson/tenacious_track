require 'test_helper'

class ElementEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:stephen)
    @element1 = elements(:one)
    @category1 = element_categories(:one)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_element_path(@element1)
    assert_template 'elements/edit'
    patch element_path(@element1), params: {
      element: {element_category: @category1,
      name: "Prone"}}
    assert_redirected_to elements_path
    follow_redirect!
    assert_template 'index'
  end
end
