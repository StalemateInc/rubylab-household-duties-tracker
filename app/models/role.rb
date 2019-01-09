class Role < ApplicationRecord
  has_many :memberships
  enum role: %i[child adult group_owner]
end
