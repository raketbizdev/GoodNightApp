require "test_helper"

class Api::V1::LandingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_landings_index_url
    assert_response :success
  end
end
