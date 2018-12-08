# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# devise stores encrypted passwords, so if we generate them at random we won't be able to log in as any of users
PASSWORDS = %w[qwerty AlQdI70rAlAoGnV QcKn8mTqQ4Xv5f2c Jz9hFvN24uAjQp DeRhJoD1 R7HrI9L5ZaOlPv
               NzYj1tTkM Ht5cH8Aj AtDdUoFzAp L1MhIyDjZz So1fAl6iDiUoU IoJ0CkH27b1 Uq3iIbGa
               Xq3kUwSf18I09gQ HvT506P0T AjFnCiAkG6 9rB2Pl3qXx P8VoT4Ci2 20Ql5yJx7rTzQ9G Vr56OhIsM5L6].freeze

PASSWORDS.length.times do |n|
  User.create(
    email: Faker::Internet.email,
    password: PASSWORDS[n],
    display_name: Faker::Name.first_name + ' ' + Faker::Name.last_name,
    profile_picture_path: nil,
    confirmed_at: Time.now,
    confirmation_sent_at: Time.now - 10.seconds
  )
end

(PASSWORDS.length / 2).times do |n|
  Group.create(
    name: 'The ' + Faker::Name.last_name.pluralize,
    password: 'asdfzx'
  )
end

users = User.all.to_a
groups = Group.all.to_a
adult_role = Role.find_by(text_name: 'adult')
10.times do
  user = users[Random.rand(10)]
  group = groups[Random.rand(5)]
  Membership.create(
    group_id: group.id,
    user_id: user.id,
    role_id: adult_role.id
  )
end