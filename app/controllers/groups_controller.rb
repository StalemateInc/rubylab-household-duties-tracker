class GroupsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  authorize_resource
  before_action :find_group, except: %i[index create new]

  # GET /groups
  def index
    @public_groups = Group.where(visible_to_all: true)
                         .page(params[:public_groups_page])
    @user_groups = current_user.groups.page(params[:user_groups_page])
  end

  # POST /groups
  def create
    @group = Group.new(group_params)
    redirect_to @group if @group.save
  end

  # GET /groups/new
  def new
    return redirect_to root_path unless can? :create, Group

    @group = Group.new
    @group.memberships.build
  end

  # GET /groups/:id/edit
  def edit
    unless can? :edit, @group
      flash[:alert] = t('cancancan.access_denied')
      redirect_to groups_path
    end
  end

  # GET groups/:id
  def show
    unless can? :read, @group
      flash[:alert] = t('cancancan.access_denied')
      redirect_to groups_path
    end
  end

  # PATCH/PUT groups/:id
  def update
    if @group.update(group_params)
      flash[:notice] = I18n.t('flash.group.update_success')
    else
      flash[:alert] = I18n.t('flash.group.update_failure')
    end
    redirect_to @group
  end

  # DELETE group/:id
  def destroy
    @group.destroy if can? :destroy, @group
    flash[:notice] = I18n.t('flash.group.destroy_success')
    redirect_to groups_path
  end

  private

  def find_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :password, :visible_to_all,
                                  memberships_attributes: %i[group_id user_id role_id])
  end
end
