class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group
    end
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def show
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to @group
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :password, :visible_to_all)
  end
end
