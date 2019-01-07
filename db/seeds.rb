require 'yaml'

def load_category(category, parent = nil)
  category.each do |key, value|
    sub = Category.create(name: key, parent: parent)
    load_category(value, sub) unless value.nil?
  end
end

if Rails.env.development?
  USER_PASSWORD = 'user_pass'.freeze
  GROUP_PASSWORD = 'group_pass'.freeze
  USERS_TO_BE_CREATED = 20
  DIVISOR_IN_HALF = 2
  CONFIRMATION_SENT_SECONDS_AGO = 10
  GROUPS_TO_BE_CREATED = USERS_TO_BE_CREATED / DIVISOR_IN_HALF
  MEMBERSHIPS_TO_BE_CREATED = GROUPS_TO_BE_CREATED

  USERS_TO_BE_CREATED.times do |n|
    User.create(
      email: "usermail#{n}@example.com",
      password: USER_PASSWORD,
      display_name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
      avatar: nil,
      confirmed_at: Time.now,
      confirmation_sent_at: CONFIRMATION_SENT_SECONDS_AGO.seconds.ago
    )
  end

  GROUPS_TO_BE_CREATED.times do
    Group.create(
      name: "The #{Faker::Name.last_name.pluralize}",
      password: GROUP_PASSWORD
    )
  end

  users = User.all
  groups = Group.all
  MEMBERSHIPS_TO_BE_CREATED.times do
    user = users.sample
    group = groups.sample
    Membership.create(
      group_id: group.id,
      user_id: user.id,
      role_id: Role.adult.id
    )
  end

  categories = YAML.load_file "lib/assets/categories.yaml"
  load_category(categories)
end
