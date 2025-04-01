require "test_helper"

class DecisionTreeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decision_tree_index_url
    assert_response :success
  end
end
