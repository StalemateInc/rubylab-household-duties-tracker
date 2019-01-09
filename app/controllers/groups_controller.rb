class GroupsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  authorize_resource
  before_action :find_group, except: %i[index create new]

  # GET /groups
  def index
    @public_groups = Group.where(visible_to_all: true) if can? :read_public, Group
    @user_groups = current_user.groups
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
    redirect_to groups_path unless can? :edit, @group
  end

  # GET groups/:id
  def show
    redirect_to groups_path unless can? :read, @group
  end

  # PATCH/PUT groups/:id
  def update
    redirect_to @group if @group.update(group_params)
  end

  # DELETE group/:id
  def destroy
    @group.destroy if can? :destroy, @group
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
