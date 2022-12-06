require 'test_helper'

class UnpaidStudentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get unpaid_students_index_url
    assert_response :success
  end

end
