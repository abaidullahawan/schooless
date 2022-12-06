require 'test_helper'

class StudentFeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_fee = student_fees(:one)
  end

  test "should get index" do
    get student_fees_url
    assert_response :success
  end

  test "should get new" do
    get new_student_fee_url
    assert_response :success
  end

  test "should create student_fee" do
    assert_difference('StudentFee.count') do
      post student_fees_url, params: { student_fee: { balance: @student_fee.balance, fee_type: @student_fee.fee_type, paid_date: @student_fee.paid_date, paid_fee: @student_fee.paid_fee, student_id: @student_fee.student_id } }
    end

    assert_redirected_to student_fee_url(StudentFee.last)
  end

  test "should show student_fee" do
    get student_fee_url(@student_fee)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_fee_url(@student_fee)
    assert_response :success
  end

  test "should update student_fee" do
    patch student_fee_url(@student_fee), params: { student_fee: { balance: @student_fee.balance, fee_type: @student_fee.fee_type, paid_date: @student_fee.paid_date, paid_fee: @student_fee.paid_fee, student_id: @student_fee.student_id } }
    assert_redirected_to student_fee_url(@student_fee)
  end

  test "should destroy student_fee" do
    assert_difference('StudentFee.count', -1) do
      delete student_fee_url(@student_fee)
    end

    assert_redirected_to student_fees_url
  end
end
