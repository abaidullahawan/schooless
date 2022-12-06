class SchoolBranchesController < ApplicationController
  before_action :set_school_branch, only: [:show, :edit, :update, :destroy]

  # GET /school_branches
  # GET /school_branches.json
  def index
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  # GET /school_branches/1
  # GET /school_branches/1.json
  def show
  end
  def new_month
    @paid_to_month = Date.today.month
    @paid_to_year = Date.today.year
    paid_students = StudentFee.where("extract(month from student_fees.paid_date) = ? AND extract(year from student_fees.paid_date) = ? AND student_fees.fee_type = ?", @paid_to_month, @paid_to_year, "Fee")
    @q = Student.where.not(id: paid_students.pluck(:student_id)).where("deleted=false AND student_type = ?", 0).ransack()
    @students = @q.result(distinct: true)
    @students.each do |student|
      balance=student.balance.present? ? student.balance : 0
      monthly_fee=student.monthly_fee.present? ? student.monthly_fee : 0
    	student.balance=balance-monthly_fee
    	student.save!
    end
    Widow.update(paid: false)
    redirect_to school_branches_path
  end
  # GET /school_branches/new
  def new
    @schoolBranch = SchoolBranch.new
  end

  # GET /school_branches/1/edit
  def edit
  end

  # POST /school_branches
  # POST /school_branches.json
  def create
    if school_branch_params[:active] ==  "1"
      SchoolBranch.update_status(current_user.school_id)
    end
    @schoolBranch = SchoolBranch.new(school_branch_params)

    respond_to do |format|
      if @schoolBranch.save
        format.html { redirect_to @schoolBranch, notice: 'School branch was successfully created.' }
        format.json { render :show, status: :created, location: @schoolBranch }
      else
        format.html { render :new }
        format.json { render json: @schoolBranch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /school_branches/1
  # PATCH/PUT /school_branches/1.json
  def update
    if school_branch_params[:active] == "1"
      SchoolBranch.update_status(current_user.school_id, @schoolBranch.id)
    end
    respond_to do |format|
      if @schoolBranch.update(school_branch_params)
        format.html { redirect_to @schoolBranch, notice: 'School branch was successfully updated.' }
        format.json { render :show, status: :ok, location: @schoolBranch }
      else
        format.html { render :edit }
        format.json { render json: @schoolBranch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_branches/1
  # DELETE /school_branches/1.json
  def destroy
    @schoolBranch.destroy
    respond_to do |format|
      format.html { redirect_to school_branches_url, notice: 'School branch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_branch
      @schoolBranch = SchoolBranch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def school_branch_params
      params.require(:school_branch).permit(:name, :address, :code, :school_id, :active)
    end
end
