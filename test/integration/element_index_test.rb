require 'test_helper'

class ElementIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:stephen)
    @non_admin = users(:archer)
    @element1 = elements(:one)
    @element2 = elements(:two)
    @category1 = element_categories(:one)
    @category2 = element_categories(:two)
  end

  test "filtering results" do
    log_in_as(@admin)
    get elements_path
    assert_template 'elements/index'
    assert_select 'ul.pagination'
    assert_select 'i', class: 'fa-trash-alt'
    assert_select 'i', class: 'fa-edit'
    assert_select 'td', text: @category1.category_name
    get elements_path, params: {
      query: [@category2.category_name]
    }
    assert_select 'td', text: @category1.category_name, count: 0
    assert_select 'td', text: @category2.category_name
  end

  test "non-admins cannot see delete or edit elements" do
    log_in_as(@non_admin)
    assert current_user?(@non_admin)
    assert_not @non_admin.admin?
    get elements_path
    assert_select 'i', class: 'fa-trash-alt', count: 0
    assert_select 'i', class: 'fa-edit', count: 0
  end



end
