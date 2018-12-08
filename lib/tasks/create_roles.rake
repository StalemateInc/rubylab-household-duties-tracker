namespace :db do
  desc 'Create a roles table and populate in with predefined roles'
  task create_roles: :environment do
    ROLES = %i[child adult group_owner].freeze
    ROLES.each do |role|
      Role.create(text_name: role.to_s).save
    end
  end
end