class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  # Image attachment with content type and size validations
  has_one_attached :image

  # validates :image,
  #           content_type: [ "image/png", "image/jpg", "image/jpeg", "image/gif" ],
  #           size: { less_than: 5.megabytes, message: "is too large. Maximum size is 5MB" }
end
