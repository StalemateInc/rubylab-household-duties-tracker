class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :read_public, Group, visible_to_all: true
      can :read, Group do |group|
        group.memberships.find_by(user: user)
      end
      can :create, Group
      can :edit, Group do |group|
        get_corresponding_role_for_group(user, group) == Role.group_owner
      end
      can :destroy, Group do |group|
        get_corresponding_role_for_group(user, group) == Role.group_owner
      end
      can :add_users, Group do |group|
        get_corresponding_role_for_group(user, group).in?([Role.adult, Role.group_owner])
      end
      can :remove_users, Group do |group|
        get_corresponding_role_for_group(user, group) == Role.group_owner
      end
      can :manage_roles, Group do |group|
        get_corresponding_role_for_group(user, group) == Role.group_owner
      end
      can :read_public, Task
      can :read, Task do |task|
        task.creator == user || task.executor == user ||
          get_corresponding_role_for_group(user, task.group).in?([Role.group_owner, Role.adult])
      end
      can :create, Task
      can :edit, Task do |task|
        task.executor != user && (task.creator == user ||
          get_corresponding_role_for_group(user, task.group).in?([Role.adult, Role.group_owner]))
      end
      can(:destroy, Task) { |task| task.creator == user }
      can(:estimate, Task) { |task| task.executor == user }
      can(:start, Task) { |task| task.creator == user }
      can :pause, Task do |task|
        [task.executor, task.creator].include?(user)
      end
      can :resume, Task do |task|
        [task.executor, task.creator].include?(user)
      end
      can(:stop, Task) { |task| task.creator == user }
      can(:rate, Task) { |task| task.creator == user }
      can :comment, Task
    end
  end

  private

  def find_corresponding_group_for_task(task)
    Group.find(task.group)
  end

  def get_corresponding_role_for_group(user, group)
    member = user.memberships.find_by(group: group)
    member&.role
  end
end
