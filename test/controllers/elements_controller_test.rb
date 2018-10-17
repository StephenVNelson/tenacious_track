require 'test_helper'

class ElementsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:stephen)
    @non_admin = users(:archer)
    @element1 = elements(:one)
    @element2 = elements(:two)
  end


  test "should redirect index when not logged in" do
    get elements_path
    assert_redirected_to login_url
  end

  test "should redirect new when not logged in" do
    get new_element_path
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_element_path(@admin)
    assert_redirected_to login_url
  end

  test "non-admins cannot delete or edit elements" do
    log_in_as(@non_admin)
    assert_not @non_admin.admin?
    patch element_path(@element1), params: {element: {series_name: "Body Position", name: "Squating Tiger"}}
    @element1.reload
    assert_not_equal @element1.name, "Squating Tiger"
  end

  test "admins can edit elements" do
    log_in_as(@admin)
    patch element_path(@element1), params: {element: {series_name: "Body Position", name: "Squating Tiger"}}
    @element1.reload
    assert_equal @element1.name, "Squating Tiger"
  end


end
