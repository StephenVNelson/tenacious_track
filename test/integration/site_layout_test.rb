require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "Header links work" do
    get root_path
    assert_response :success
  
  end
end
