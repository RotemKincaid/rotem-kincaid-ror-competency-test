# test/integration/articles_access_test.rb
require "test_helper"

class ArticlesAccessTest < ActionDispatch::IntegrationTest
  setup do
    Session.delete_all
    Article.delete_all
    User.delete_all

    @editor = User.create!(email_address: "editor@test.com", password: "password", roles: [:editor, :user])
    @editor2 = User.create!(email_address: "editor2@test.com", password: "password", roles: [:editor, :user])
    @user = User.create!(email_address: "user@test.com", password: "password", roles: [:user])

    @editors_article = Article.create!(title: "Mine", content: "abc", category: "Tech", user: @editor)
    @other_article = Article.create!(title: "Not mine", content: "xyz", category: "Tech", user: @editor2)
  end

  test "guest can view articles index" do
    get articles_path
    assert_response :success
  end

  test "guest is redirected from article show" do
    get article_path(@editors_article)
    assert_redirected_to new_session_path
  end

  test "vanilla user can view article show" do
    sign_in_as(@user)

    get article_path(@editors_article)
    assert_response :success
    assert_includes response.body, @editors_article.title
  end

  test "vanilla user cannot access new article page" do
    sign_in_as(@user)

    get new_article_path
    assert_redirected_to root_path
  end

  test "editor can edit own article" do
    sign_in_as(@editor)

    get edit_article_path(@editors_article)
    assert_response :success
  end

  test "editor cannot edit someone else's article" do
    sign_in_as(@editor)

    get edit_article_path(@other_article)

    assert_response :redirect
    assert_includes [root_path, articles_path], URI.parse(response.location).path
  end

  test "editor can create an article" do
    sign_in_as(@editor)

    assert_difference("Article.count", 1) do
      post articles_path, params: { article: { title: "New", content: "Body", category: "News" } }
    end

    assert_redirected_to article_path(Article.last)
  end

  private

  def sign_in_as(user, password: "password")
    before = Session.count

    post session_path, params: { email_address: user.email_address, password: password }

    assert_response :redirect
    assert_equal before + 1, Session.count

    follow_redirect!
  end
end
