class Task < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :executor, class_name: 'User'
  belongs_to :group
  enum status: %i[opened ready in_progress paused finished closed]
  validates :rating, inclusion: { in: 0..5 }

  def reject_estimation
    update(expires_at: nil, status: :opened)
  end

  def confirm_estimation
    update(status: :in_progress)
  end

end
