class Task < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :executor, class_name: 'User'
  belongs_to :group
  has_many :comments, as: :commentable, dependent: :destroy
  enum status: %i[opened pending in_progress paused finished closed]
  validates :rating, inclusion: { in: 0..5 }

  def stoppable?
    !(finished? || closed?)
  end
end
