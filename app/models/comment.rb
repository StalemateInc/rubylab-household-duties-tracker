class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :comments, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy
  enum comment_type: %i[regular postpone acceptance rejection]
  validates :content, presence: true, allow_blank: true

  scope :last_postpone_comment, ->(subject) { where(comment_type: :postpone, commentable: subject).last }

  def edited?
    created_at != updated_at
  end
end
