class Role < ApplicationRecord
  has_many :memberships
  enum role: %i[child adult group_owner]

  roles.each do |role, _n|
    define_singleton_method(role.to_sym) do
      Role.find_by(role: role.to_sym)
    end
  end
end
