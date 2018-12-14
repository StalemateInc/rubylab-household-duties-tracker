class Task < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :executor, class_name: 'User'
  belongs_to :group
end
