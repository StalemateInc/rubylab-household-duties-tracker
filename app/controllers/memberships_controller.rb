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
      membership = { user: @user, role: Role.child.last }
      @membership = @group.memberships.build(membership)
      if @membership.save
        flash[:notice] = I18n.t('flash.group.invite_success', email: @user.email)
      else
        flash[:alert] = I18n.t('flash.group.invite_failure')
      end
    end
    redirect_to group_path(@group)
  end

  def destroy
    @membership = current_user.memberships.find_by(group: @group)
    @member_id = @membership.id
    if @membership.destroy
      flash[:notice] = I18n.t('flash.group.leave_success')
      respond_to do |format|
        format.html { redirect_to groups_path }
        format.js { render 'memberships/destroy' }
      end
    end
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
  end

end
