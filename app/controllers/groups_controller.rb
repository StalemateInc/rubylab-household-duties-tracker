class GroupsController < ApplicationController
  before_action :find_group, except: %i[index create new]

  # GET /groups
  def index
    unless can? :read_public, Group
      redirect_to root_path
      return
    end
    @groups = current_user.groups
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group
    end
  end

  # GET /groups/new
  def new
    unless can? :create, Group
      redirect_to root_path
      return
    end
    @group = Group.new
    @group.memberships.build
  end

  # GET /groups/:id/edit
  def edit
    redirect_to groups_path unless can? :update, @group
  end

  # GET groups/:id
  def show
    redirect_to root_path unless can? :read, @group
  end

  # PATCH/PUT groups/:id
  def update
    if @group.update(group_params)
      redirect_to @group
    end
  end

  # DELETE group/:id
  def destroy
    if can? :destroy, @group
      @group.destroy
    end

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
