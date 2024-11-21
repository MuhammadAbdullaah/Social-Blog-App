class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true
  belongs_to :parent, class_name: "Comment", optional: true

  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  # Optional: validation to ensure that content is present before saving a comment
  validates :content, presence: true
end
