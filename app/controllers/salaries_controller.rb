class SalariesController < ApplicationController
  before_action :set_salary, only: [:show, :edit, :update, :destroy, :show_advance, :edit_advance, :salary_info_for_teacher]

  # GET /salaries
  # GET /salaries.json
  def index
    if params[:salary].present?
      @paid_to_month = params[:salary][:month]
      @paid_to_year = params[:salary][:year]
    else
      @paid_to_month = Date.today.month
      @paid_to_year = Date.today.year
    end
    @q = Salary.where("extract(month from created_at) = ? AND extract(year from created_at) = ?", @paid_to_month, @paid_to_year).ransack(params[:q])
    if @q.result.count > 0
      @q.sorts = 'id asc' if @q.sorts.empty?
    end
    if params[:q].present?
      @paid_to = params[:q][:paid_to_eq]
      @payment_type = params[:q][:payment_type_eq]
      @school_branch_id = params[:q][:school_branch_id_eq]
      @school_branch_id = params[:q][:school_branch_id_eq]
    end
    @salaries = @q.result(distinct: true).page(params[:page])
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  # GET /salaries/1
  # GET /salaries/1.json
  def show
  end

  # GET /salaries/1
  # GET /salaries/1.json
  def show_advance
  end

  # GET /salaries/new
  def new
    @teachers_list = activated_list("Teacher")
    @staffs_list = activated_list("Staff")
    @salary = Salary.new(payment_type: :Salary)
  end

  def advance
    @teachers_list = activated_list("Teacher")
    @staffs_list = activated_list("Staff")
    @salary = Salary.new(payment_type: :Advance)
  end

  # GET /salaries/1/edit
  def edit
    @teachers_list = activated_list("Teacher")
    @staffs_list = activated_list("Staff")
  end

  # GET /salaries/1/edit
  def edit_advance
    @teachers_list = activated_list("Teacher")
    @staffs_list = activated_list("Staff")
  end
  # POST /salaries
  # POST /salaries.json
  def salary_info_for_teacher
    request.format = 'pdf'
    respond_to do |format|
      if @salary.paid_to=="Teacher"
        format.pdf do
          render pdf: "Teacher",
          layout: 'pdf.html',
          page_size: 'A8',
          title: "Teacher Salary",
          encoding: "UTF-8",
          show_as_html: true
        end
      end
    end
  end
  def create
    @salary = Salary.new(salary_params)

    respond_to do |format|
      if @salary.save
        if @salary.paid_to=="Teacher"
          format.html { redirect_to teachers_path, notice: @salary.payment_type+' was successfully created.' }
        else
          format.html { redirect_to staffs_path, notice: @salary.payment_type+' was successfully created.' }
        end
        format.json { render :show, status: :created, location: @salary }
      else
        format.html { render :new }
        format.json { render json: @salary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /salaries/1
  # PATCH/PUT /salaries/1.json
  def update
    respond_to do |format|
      if @salary.update(salary_params)
        format.html { redirect_to @salary.Salary? ? @salary : show_advance_salary_path(@salary), notice: @salary.payment_type+' was successfully updated.' }
        format.json { render :show, status: :ok, location: @salary }
      else
        format.html { render :edit }
        format.json { render json: @salary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /salaries/1
  # DELETE /salaries/1.json
  def destroy
    @salary.destroy
    respond_to do |format|
      format.html { redirect_to salaries_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_salary
      @salary = Salary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def salary_params
      params.require(:salary).permit(:payment_type, :paid_to, :paid_salary, :advance, :leaves_in_month, :teacher_id, :staff_id, :school_branch_id)
    end

    def activated_list(model_name)
      model_name.constantize.where(terminated: false, deleted: false)
    end
end
