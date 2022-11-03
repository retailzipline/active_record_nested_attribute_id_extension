class Post < ActiveRecord::Base
  has_many :comments
  has_one :image

  accepts_nested_attributes_for :comments, :image
end
