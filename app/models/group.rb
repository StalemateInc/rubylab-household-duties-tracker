class Group < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships, dependent: :destroy
end
