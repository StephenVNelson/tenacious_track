require 'test_helper'

class ElementIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:stephen)
    @non_admin = users(:archer)
    @element1 = elements(:one)
    @element2 = elements(:two)
  end

  test "delete returns user to filtered page" do
    log_in_as(@admin)
    get elements_path
    assert_template 'elements/index'
    assert_select 'ul.pagination'
    assert_select 'a', text: 'delete'
    assert_select 'a', text: 'edit'
    first_page_of_elements = Element.where(series_name: "Body Position").paginate(page: 1, :per_page => 15)
    first_page_of_elements.each do |element|
      assert element.series_name, "Body Position"
    end
    delete element_path(@element1.id, series: "Body Position")
    assert_redirected_to elements_path(series: "Body Position")
  end

  test "non-admins cannot see delete or edit elements" do
    log_in_as(@non_admin)
    assert current_user?(@non_admin)
    assert_not @non_admin.admin?
    get elements_path
    assert_select 'a', text: 'delete', count: 0
    assert_select 'a', text: 'edit', count: 0
  end



end
