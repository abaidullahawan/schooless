class StudentFeesController < ApplicationController
  before_action :authenticate_user!, :active_branch
  before_action :set_student_fee, only: [:show, :edit, :update, :destroy]

  # GET /student_fees
  # GET /student_fees.json
  def index
    if params[:student_fees].present?
      @paid_to_month = params[:student_fees][:month]
      @paid_to_year = params[:student_fees][:year]
    else
      @paid_to_month = Date.today.month
      @paid_to_year = Date.today.year
    end
    @q = StudentFee.joins(:student).where("extract(month from student_fees.paid_date) = ? AND extract(year from student_fees.paid_date) = ? AND students.deleted = ?", @paid_to_month, @paid_to_year, false).ransack(params[:q])
    if @q.result.count > 0
      @q.sorts = 'id asc' if @q.sorts.empty?
    end
    if params[:q].present?
      @name= params[:q][:student_name_cont]
      @father= params[:q][:student_father_name_cont]
      @school_branch_id = params[:q][:student_school_branch_id_eq]
    end
    @student_fees = @q.result(distinct: true).page(params[:page])
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  # GET /student_fees/1
  # GET /student_fees/1.json
  def show
  end

  # GET /student_fees/new
  def new
    @student_fee = StudentFee.new
    @students_list = Student.select(:id, :name, :father_name, :monthly_fee, :balance)
    #@students_list = Student.left_joins(:student_fees).where("extract(month from student_fees.paid_date) != ? OR student_fees.fee_type != ? OR student_fees.student_id IS ?", Date.today.month, "Fee", nil).uniq.select(:id, :name, :monthly_fee, :balance)
  end

  # GET /student_fees/1/edit
  def edit
    @students_list = Student.select(:id, :name, :father_name, :monthly_fee, :balance)
  end

  # POST /student_fees
  # POST /student_fees.json
  def create
    @student_fee = StudentFee.new(student_fee_params)

    respond_to do |format|
      if @student_fee.save
        @student_fee.student.update(balance: student_fee_params[:balance])
        format.html { redirect_to students_path, notice: 'Student fee was successfully created.' }
        format.json { render :show, status: :created, location: @student_fee }
      else
        format.html { render :new }
        format.json { render json: @student_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_fees/1
  # PATCH/PUT /student_fees/1.json
  def update
    already_paid = @student_fee.paid_fee
    new_paid = params[:student_fee][:paid_fee]
    params[:student_fee][:paid_fee] = already_paid.to_i + new_paid.to_i
    respond_to do |format|
      if @student_fee.update(student_fee_params)
        @student_fee.student.update(balance: student_fee_params[:balance])
        format.html { redirect_to students_path, notice: 'Student fee was successfully updated.' }
        format.json { render :show, status: :ok, location: @student_fee }
      else
        format.html { render :edit }
        format.json { render json: @student_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_fees/1
  # DELETE /student_fees/1.json
  def destroy
    @student_fee.destroy
    respond_to do |format|
      format.html { redirect_to student_fees_url, notice: 'Student fee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_monthly_fee_balance
    student_fee = StudentFee.where('extract(month from paid_date) = ? AND extract(year from paid_date) = ? AND fee_type =? AND student_id= ?', Date.today.month, Date.today.year, "Fee", params[:student_id])
    student = Student.find_by(id: params[:student_id])
    if student_fee.present?
      st_monthly_fee = "#{student.name} has already paid fee."
      need_fee_option = "no"
    else
      st_monthly_fee = student.monthly_fee
      need_fee_option = "yes"
    end

    respond_to do |format|
      format.json { render json: {status: 'success',father_name: student.father_name, school_branch: student.school_branch.name,level: student.class_section.level.name,section: student.class_section.section.name ,balance: student.balance, monthly_fee: st_monthly_fee, need_fee_option: need_fee_option }, status: :ok}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_fee
      @student_fee = StudentFee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_fee_params
      params.require(:student_fee).permit(:paid_date, :paid_fee, :fee_type, :student_id, :balance)
    end
end
