class Group < ApplicationRecord
  has_many :memberships, inverse_of: :group
  has_many :users, through: :memberships, dependent: :destroy
  accepts_nested_attributes_for :memberships
end
