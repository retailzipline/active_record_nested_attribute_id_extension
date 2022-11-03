require "test_helper"

class ActiveRecordNestedAttributeIdExtensionTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert ActiveRecordNestedAttributeIdExtension::VERSION
  end

  test "it supports a collection association" do
    post = Post.create!(comments_attributes: { id: 5, _create: 1 })

    assert_equal 1, post.comments.count
    assert_equal 1, Comment.count
    assert_equal 5, Comment.first.id
    assert_equal post.id, Comment.first.post.id
  end

  test "it supports a one to one association" do
    post = Post.create!(image_attributes: { id: 5, _create: 1 })

    assert post.image.present?
    assert_equal 1, Image.count
    assert_equal 5, Image.first.id
    assert_equal post.id, Image.first.post.id
  end
end
