class MembershipsController < ApplicationController
  layout "dashboard"
  before_action :find_group
  before_action :authenticate_user!


  def new
    authorize! :add_users, @group
  end

  def create
    authorize! :add_users, @group
    @user = User.find_by(email: params[:user][:email])
    unless Membership.exists?(user_id: @user, group_id: @group)
      membership = { user: @user, role: Role.child }
      @membership = @group.memberships.build(membership)
      @membership.save
    end
    redirect_to group_path(@group)
  end

  def destroy
    @membership = current_user.memberships.find_by(group: @group)
    if @membership.destroy
      redirect_to groups_path
    end
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
  end

end
