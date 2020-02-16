require 'test_helper'

class WordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @word = words(:one)
  end

  test "should get index" do
    get words_url, as: :json
    assert_response :success
  end

  test "should create word" do
    assert_difference('Word.count') do
      post words_url, params: { word: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show word" do
    get word_url(@word), as: :json
    assert_response :success
  end

  test "should update word" do
    patch word_url(@word), params: { word: {  } }, as: :json
    assert_response 200
  end

  test "should destroy word" do
    assert_difference('Word.count', -1) do
      delete word_url(@word), as: :json
    end

    assert_response 204
  end
end
