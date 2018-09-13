require 'test_helper'

class ElementsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @element1 = elements(:one)
  end


  test "should redirect index when not logged in" do
    get elements_index_url
    assert_redirected_to login_url
  end

  test "should redirect new when not logged in" do
    get elements_new_url
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get elements_edit_url
    assert_redirected_to login_url
  end

end
