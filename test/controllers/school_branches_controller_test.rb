require 'test_helper'

class SchoolBranchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school_branch = school_branches(:one)
  end

  test "should get index" do
    get school_branches_url
    assert_response :success
  end

  test "should get new" do
    get new_school_branch_url
    assert_response :success
  end

  test "should create school_branch" do
    assert_difference('SchoolBranch.count') do
      post school_branches_url, params: { school_branch: { address: @school_branch.address, code: @school_branch.code, name: @school_branch.name, school_id: @school_branch.school_id } }
    end

    assert_redirected_to school_branch_url(SchoolBranch.last)
  end

  test "should show school_branch" do
    get school_branch_url(@school_branch)
    assert_response :success
  end

  test "should get edit" do
    get edit_school_branch_url(@school_branch)
    assert_response :success
  end

  test "should update school_branch" do
    patch school_branch_url(@school_branch), params: { school_branch: { address: @school_branch.address, code: @school_branch.code, name: @school_branch.name, school_id: @school_branch.school_id } }
    assert_redirected_to school_branch_url(@school_branch)
  end

  test "should destroy school_branch" do
    assert_difference('SchoolBranch.count', -1) do
      delete school_branch_url(@school_branch)
    end

    assert_redirected_to school_branches_url
  end
end
