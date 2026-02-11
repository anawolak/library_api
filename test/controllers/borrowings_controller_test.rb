require "test_helper"

class BorrowingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @borrowing = borrowings(:one)
  end

  test "should get index" do
    get borrowings_url, as: :json
    assert_response :success
  end

  test "should create borrowing" do
    assert_difference("Borrowing.count") do
      post borrowings_url, params: { borrowing: { book_id: @borrowing.book_id, user_id: @borrowing.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show borrowing" do
    get borrowing_url(@borrowing), as: :json
    assert_response :success
  end

  test "should update borrowing" do
    patch borrowing_url(@borrowing), params: { borrowing: { book_id: @borrowing.book_id, user_id: @borrowing.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy borrowing" do
    assert_difference("Borrowing.count", -1) do
      delete borrowing_url(@borrowing), as: :json
    end

    assert_response :no_content
  end
end
