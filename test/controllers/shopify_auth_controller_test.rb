require 'test_helper'

class ShopifyAuthControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get shopify_auth_login_url
    assert_response :success
  end

end
