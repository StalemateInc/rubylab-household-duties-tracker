class GroupsController < ApplicationController

  # GET /groups
  def index
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
    @group = Group.new
  end

  # GET /groups/:id/edit
  def edit
    redirect_to groups_path unless check_priviledge
    @group = Group.find(params[:id])
  end

  # GET groups/:id
  def show
    @group = Group.find(params[:id])
    redirect_to root_path unless check_priviledge
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
    @group.destroy

    redirect_to groups_path
  end

  private

  def check_priviledge
    current_user.groups.include?(Group.find(params[:id])) &&
        current_user.memberships.find_by(group_id: params[:id]).role == "adult"
  end

  def add_current_user_as_adult(group)
    membership = Membership.create(
      group_id: group.id,
      user_id: current_user.id,
      role: :adult
    )
    membership.save
  end

  def group_params
    params.require(:group).permit(:name, :password, :visible_to_all)
  end
end
