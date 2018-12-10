namespace :db do
  desc 'Create a roles table and populate in with predefined roles'
  task create_roles: :environment do
    Role.roles.each do |name, value|
      Role.create(name: name, role: value).save
    end
  end
end