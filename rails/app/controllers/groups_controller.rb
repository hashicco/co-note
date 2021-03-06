class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :check_permission_for_read, only: [:show]
  before_action :check_permission_for_write, only: [:edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.owned_by(current_user)
                   .order(:name)
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    @group.owner = current_user
    @group.rest_users_size.times do
      @group.group_users.build
    end
   end

  # GET /groups/1/edit
  def edit
    @group.rest_users_size.times do
      @group.group_users.build
    end
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.friendly.find(params[:id])
    end

    def check_permission_for_read
      unless @group.owned_by?(current_user)
        redirect_to groups_path, alert: 'You cannot read this group.' 
        return
      end
    end

    def check_permission_for_write
      unless @group.owned_by?(current_user)
        redirect_to groups_path, alert: 'You cannot write this group.' 
        return
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      _group_params = params.require(:group).permit(:name, group_users_attributes: [:id, :user_id])
      _group_params["group_users_attributes"].each do | k, v |
        v["_destroy"] = true if v["user_id"].blank?
      end
      _group_params
    end
end
