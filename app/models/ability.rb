class Ability
  include CanCan::Ability

  def get_corresponding_role_for_group(user, group)
    member = user.memberships.find_by(group_id: group.id)
    member&.role&.text_name
  end

  def initialize(user)
    if user.present?
      can :read_public, Group, visible_to_all: true
      can :read, Group do |group|
        get_corresponding_role_for_group(user, group).in?(%w(adult group_owner))
      end
      can :create, Group
      can :update, Group do |group|
        get_corresponding_role_for_group(user, group) == 'group_owner'
      end
      can :destroy, Group do |group|
        get_corresponding_role_for_group(user, group) == 'group_owner'
      end
    end
  end
end
