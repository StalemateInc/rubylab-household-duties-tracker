require 'csv'
require 'yaml'

def load_flat_csv(file)
  CSV.foreach(file).with_object([]) { |row, ary| ary.push(row) }
end

def load_category(category, parent = nil)
  category.each do |key, value|
    sub = Category.create(name: key, parent: parent)
    load_category(value, sub) unless value.nil?
  end
end

# seeds for presentation
if Rails.env.development?
  USER_PASSWORD = 'user_pass'.freeze
  GROUP_PASSWORD = 'group_pass'.freeze
  CONFIRMATION_SENT_SECONDS_AGO = 10
  ASSETS_PATH = 'lib/assets'.freeze
  AVATARS_PATH = ASSETS_PATH + '/avatars'
  MAX_DAYS_SPAN = 4
  MAX_HOURS_SPAN = 24
  MAX_MINUTES_SPAN = 60
  RATING_ZERO = 0
  RATING_MIN = 1
  RATING_MAX = 5

  # users creation
  users = load_flat_csv(ASSETS_PATH + '/users.csv')
  USERS_TO_BE_CREATED = users.length
  users.each_with_index do |user, n|
    user = User.create!(
      email: "usermail#{n}@example.com",
      password: USER_PASSWORD,
      display_name: user[0].to_s,
      avatar: nil,
      confirmed_at: Time.now,
      confirmation_sent_at: CONFIRMATION_SENT_SECONDS_AGO.seconds.ago
    )
    user.avatar = Rails.root.join(AVATARS_PATH + "/face_#{n}.jpg").open
    user.save!
  end

  # groups creation
  groups = load_flat_csv(ASSETS_PATH + '/groups.csv')
  GROUPS_TO_BE_CREATED = groups.length
  groups.each do |group|
    group = Group.create!(
      name: group[0].to_s,
      password: GROUP_PASSWORD,
      visible_to_all: group[1] == '0'
    )
    group.save!
  end

  # categories creation
  categories = YAML.load_file(ASSETS_PATH + '/categories.yaml')
  load_category(categories)

  # tag list load
  tags = load_flat_csv(ASSETS_PATH + '/tags.csv').flatten!

  # assigning users to groups
  users.length.times do |n|
    user = User.find(n + 1)
    group = Group.find((n % GROUPS_TO_BE_CREATED) + 1)
    Membership.create(
      group: group,
      user: user,
      role: n < GROUPS_TO_BE_CREATED ? Role.group_owner.last : Role.child.last
    )
  end

  # tasks creation
  # localized to particular group for display purposes
  tasks = load_flat_csv(ASSETS_PATH + '/tasks.csv')
  TASKS_TO_BE_CREATED = tasks.length
  group = Group.last
  creator = User.find(4)
  executors = group.users.where.not(id: creator.id).to_a
  categories = Category.all
  tasks.length.times do |n|
    status = n % Task.statuses.length
    expires_at = if status == Task.statuses[:opened]
                   nil
                 elsif status.in? [Task.statuses[:finished], Task.statuses[:closed]]
                   Time.now - rand(MAX_DAYS_SPAN).days - rand(MAX_HOURS_SPAN).hours - rand(MAX_MINUTES_SPAN).minutes
                 else
                   Time.now + rand(MAX_DAYS_SPAN).days + rand(MAX_HOURS_SPAN).hours + rand(MAX_MINUTES_SPAN).minutes
                 end
    new_expires_at = if status == Task.statuses[:paused]
                       expires_at + rand(MAX_DAYS_SPAN).days + rand(MAX_HOURS_SPAN).hours + rand(MAX_MINUTES_SPAN).minutes
                     end
    rating = rand(RATING_MIN..RATING_MAX) if status == Task.statuses[:closed]
    executor = executors.rotate!.first
    task = Task.create!(
      title: tasks[n][0],
      description: tasks[n][1],
      executor: executor,
      creator: creator,
      group: group,
      visible_to_all: tasks[n][2] == '0',
      status: status,
      expires_at: expires_at,
      new_expires_at: new_expires_at,
      category: categories.sample,
      rating: rating || RATING_ZERO
    )
    task.tag_list.add(tags.sample(3))
    task.save!
  end

  # elasticsearch reindexing
  begin
    Task.__elasticsearch__.delete_index!
    Task.import(force: true)
    Group.__elasticsearch__.delete_index!
    Task.import(force: true)
  rescue Faradey::ConnectionFailed => e
    puts 'Elasticsearch is unavailable. Please, start Elasticsearch to reindex seeds.'
    puts "An exception was thrown: #{e.message}"
  end
  # fails, reindex manually via rails c

end