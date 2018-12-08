namespace :db do
  desc 'Create a roles table and populate in with predefined roles'
  task create_roles: :environment do
    ROLES = %w[child adult group_owner].freeze
    ROLES.each do |role|
      Role.create(text_name: role).save
    end
  end
end