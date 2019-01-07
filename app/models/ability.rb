class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :read_public, Group, visible_to_all: true
      can :read, Group do |group|
        group.visible_to_all? || member?(group, user)
      end
      can :create, Group
      can :edit, Group do |group|
        find_corresponding_role_for_group(user, group).group_owner? if member?(group, user)
      end
      can :destroy, Group do |group|
        find_corresponding_role_for_group(user, group).group_owner?
      end
      can :add_users, Group do |group|
        find_corresponding_role_for_group(user, group).in?([Role.adult.last, Role.group_owner.last])
      end
      can :remove_users, Group do |group|
        find_corresponding_role_for_group(user, group).group_owner?
      end
      can :manage_roles, Group do |group|
        find_corresponding_role_for_group(user, group).group_owner?
      end
      can :read_public, Task
      can :read, Task do |task|
        creator?(task, user) || executor?(task, user) ||
            find_corresponding_role_for_group(user, task.group).in?([Role.group_owner.last, Role.adult.last])
      end
      can :create, Task
      can :edit, Task do |task|
        !executor?(task, user) && (creator?(task, user) ||
          find_corresponding_role_for_group(user, task.group).in?([Role.adult.last, Role.group_owner.last]))
      end
      can(:destroy, Task) { |task| creator?(task, user)}
      can(:estimate, Task) { |task| executor?(task, user) }
      can(:start, Task) { |task| creator?(task, user) }
      can :pause, Task do |task|
        [task.executor, task.creator].any? user
      end
      can :resume, Task do |task|
        [task.executor, task.creator].any? user
      end
      can(:stop, Task) { |task| creator?(task, user) }
      can(:rate, Task) { |task| creator?(task, user) }
      can :comment, Task
    end
  end

  private

  def executor?(task, user)
    task.executor == user
  end

  def creator?(task, user)
    task.creator == user
  end

  def member?(group, user)
    group.memberships.find_by(user: user).present?
  end

  def find_corresponding_role_for_group(user, group)
    member = user.memberships.find_by(group: group)
    member&.role
  end
end
