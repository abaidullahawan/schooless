class StaffsController < ApplicationController
  before_action :authenticate_user!, :active_branch
  before_action :set_staff, only: [:show, :edit, :update, :destroy, :salary_info]

  # GET /staffs
  # GET /staffs.json
  def index
    @q = Staff.where(deleted: false).ransack(params[:q])
    if @q.result.count > 0
      @q.sorts = 'id asc' if @q.sorts.empty?
    end
    if params[:q].present?
      @name = params[:q][:name_cont]
      @father = params[:q][:father_cont]
      @school_branch_id = params[:q][:school_branch_id_eq]
    end
    @staffs = @q.result(distinct: true).page(params[:page])

    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
    @staffs_pays = Salary.where("extract(month from created_at) = ? AND extract(year from created_at) = ? AND staff_id IN (?)", Date.today.month, Date.today.year,Staff.pluck(:id)).where(:paid_to=>'Staff')
    if params[:pdf_submit]
      request.format = 'pdf'
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "Staff",
          layout: 'pdf.html',
          page_size: 'A4',
          title: "Teacher List",
          encoding: "UTF-8",
          show_as_html: false
        end
      end
    end
  end

  # GET /staffs/1
  # GET /staffs/1.json
  def show
  end

  # GET /staffs/new
  def new
    @staff = Staff.new
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  # GET /staffs/1/edit
  def edit
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  # POST /staffs
  # POST /staffs.json
  def create
    @staff = Staff.new(staff_params)

    respond_to do |format|
      if @staff.save
        format.html { redirect_to @staff, notice: 'Staff was successfully created.' }
        format.json { render :show, status: :created, location: @staff }
      else
        @school_branches = SchoolBranch.where(school_id: current_user.school_id)
        format.html { render :new }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staffs/1
  # PATCH/PUT /staffs/1.json
  def update
    respond_to do |format|
      if @staff.update(staff_params)
        format.html { redirect_to @staff, notice: 'Staff was successfully updated.' }
        format.json { render :show, status: :ok, location: @staff }
      else
        format.html { render :edit }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staffs/1
  # DELETE /staffs/1.json
  def destroy
    @staff.update(deleted: true)
    respond_to do |format|
      format.html { redirect_to staffs_url, notice: 'Staff was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def salary_info
    respond_to do |format|
      format.json { render json: {status: 'success', advance_amount: @staff.advance_amount, monthly_salary: @staff.monthly_salary, daily_Salary: (@staff.monthly_salary.to_f / (Time.days_in_month Date.today.month)).round(2) }, status: :ok}
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff
      @staff = Staff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_params
      params.require(:staff).permit(:name, :father, :education, :gender, :phone, :address, :cnic, :date_of_joining, :date_of_leaving, :yearly_increment, :monthly_salary, :school_branch_id)
    end
end
