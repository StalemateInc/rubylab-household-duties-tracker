class MembershipsController < ApplicationController
  layout "dashboard"
  before_action :find_group

  def new; end

  def create
    @user = User.find_by(email: params[:user][:email])
    unless Membership.exists?(user_id: @user, group_id: @group)
      membership = { user: @user, role: Role.child }
      @membership = @group.memberships.build(membership)
      @membership.save
    end
    redirect_to group_path(@group)
  end

  def destroy; end

  private

  def find_group
    @group = Group.find(params[:group_id])
  end

end
