if Rails.env.development?
  PASSWORDS_FOR_USERS = []
  CSV.foreach('lib/data/seeds_passwords.csv') do |row|
    PASSWORDS_FOR_USERS << row[0]
  end
  GROUPS_TO_BE_CREATED = PASSWORDS_FOR_USERS.length / 2
  MEMBERSHIPS_TO_BE_CREATED = GROUPS_TO_BE_CREATED

  PASSWORDS_FOR_USERS.each do |password|
    User.create(
      email: Faker::Internet.email,
      password: password,
      display_name: Faker::Name.first_name + ' ' + Faker::Name.last_name,
      profile_picture_path: nil,
      confirmed_at: Time.now,
      confirmation_sent_at: Time.now - 10.seconds
    )
  end

  GROUPS_TO_BE_CREATED.times do
    Group.create(
      name: 'The ' + Faker::Name.last_name.pluralize,
      password: 'asdfg'
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
end
