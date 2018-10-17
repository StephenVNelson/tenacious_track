require 'test_helper'

class ElementCategoriesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:stephen)
    @non_admin = users(:archer)
    @category1 = element_categories(:one)
    @category2 = element_categories(:two)
  end

  test "should get index and edit" do
    log_in_as(@admin)
    get element_categories_url
    assert_response :success
    get edit_element_category_url(@category1)
    assert_response :success
  end


  test "should redirect index when not logged in" do
    get element_categories_path
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_element_category_path(@category1)
    assert_redirected_to login_url
  end

  test "non-admins cannot view categories" do
    log_in_as(@non_admin)
    assert_not @non_admin.admin?
    get element_categories_path
    assert_redirected_to user_path(@non_admin)
  end

  test "should create category if logged in" do
    log_in_as(@admin)
    get element_categories_path
    assert_difference 'ElementCategory.count', 1 do
      post element_categories_path, params: { element_category: {category_name: "Tools", sort: 3  } }
    end
    assert_redirected_to element_categories_url
  end

  test "should be able to delete category" do
    log_in_as(@admin)
    get edit_element_category_path(@category1)
    assert_response :success
    assert_difference 'ElementCategory.count', -1 do
      delete element_category_path(@category1)
    end
    assert_redirected_to element_categories_url

  end

end
