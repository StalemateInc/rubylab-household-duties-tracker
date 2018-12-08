class GroupsController < ApplicationController

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
      add_current_user_as_adult(@group)
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
  end

  # GET /groups/:id/edit
  def edit
    @group = Group.find(params[:id])
    redirect_to groups_path unless can? :update, @group
  end

  # GET groups/:id
  def show
    @group = Group.find(params[:id])
    redirect_to root_path unless can? :read, @group
  end

  # PATCH/PUT groups/:id
  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to @group
    end
  end

  # DELETE group/:id
  def destroy
    @group = Group.find(params[:id])
    if can? :destroy, @group
      @group.destroy
    end

    redirect_to groups_path
  end

  private

  def add_current_user_as_adult(group)
    membership = Membership.create(
      group_id: group.id,
      user_id: current_user.id,
      role_id: Role.find_by(text_name: 'group_owner').id
    )
    membership.save
  end

  def group_params
    params.require(:group).permit(:name, :password, :visible_to_all)
  end
end
