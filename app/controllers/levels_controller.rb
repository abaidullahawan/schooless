class LevelsController < ApplicationController
  before_action :authenticate_user!, :active_branch
  before_action :set_level, only: [:show, :edit, :update, :destroy]

  def index
    @levels = Level.where(school_branch_id: @school_branch.id)
  end

  def show

  end

  def new
    @level = Level.new
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  def create
    @level = Level.new(level_params)
    respond_to do |format|
      if @level.save
        format.html { redirect_to @level, notice: 'level was successfully created.' }
        format.json { render :show, status: :created, location: @level }
      else
        @school_branches = SchoolBranch.where(school_id: current_user.school_id)
        format.html { render :new }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  def update
    respond_to do |format|
      if @level.update(level_params)
        format.html { redirect_to @level, notice: 'level was successfully updated.' }
        format.json { render :show, status: :ok, location: @level }
      else
        format.html { render :edit }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @level.destroy
    respond_to do |format|
      format.html { redirect_to levels_url, notice: 'level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def level_params
    params.require(:level).permit(:name, :comment, :school_branch_id)
  end

  def set_level
    @level = Level.find(params[:id])
  end

end
