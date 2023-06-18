class TeachersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_teacher, only: [:show, :edit, :update, :destroy, :salary_info]

  # GET /teachers
  # GET /teachers.json
  def index
    @q = Teacher.where(deleted: false, school_branch_id: @school_branches.ids).ransack(params[:q])
    if @q.result.count > 0
      @q.sorts = 'id asc' if @q.sorts.empty?
    end
    if params[:q].present?
      @name = params[:q][:name_cont]
      @father = params[:q][:father_cont]
      @school_branch_id = params[:q][:school_branch_id_eq]
    end
    @teachers = @q.result(distinct: true).page(params[:page])

    @teachers_pays = Salary.where("extract(month from created_at) = ? AND extract(year from created_at) = ? AND teacher_id IN (?) AND school_branch_id IN (?)", Date.today.month, Date.today.year ,Teacher.pluck(:id), @school_branches.ids).where(:paid_to=>'Teacher')

    if params[:pdf_submit]
      request.format = 'pdf'
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "Teacher",
          layout: 'pdf.html',
          page_size: 'A4',
          title: "Teacher List",
          encoding: "UTF-8",
          show_as_html: false
        end
      end
    end
  end

  # GET /teachers/1
  # GET /teachers/1.json
  def show
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers
  # POST /teachers.json
  def create
    @teacher = Teacher.new(teacher_params)

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to @teacher, notice: 'Teacher was successfully created.' }
        format.json { render :show, status: :created, location: @teacher }
      else
        format.html { render :new }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachers/1
  # PATCH/PUT /teachers/1.json
  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to @teacher, notice: 'Teacher was successfully updated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1
  # DELETE /teachers/1.json
  def destroy
    @teacher.update(deleted: true)
    respond_to do |format|
      format.html { redirect_to teachers_url, notice: 'Teacher was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def salary_info
    level=@teacher.level.name rescue ''
    section=@teacher.section.name rescue ''
    respond_to do |format|
      format.json { render json: {status: 'success', advance_amount: @teacher.advance_amount, monthly_salary: @teacher.monthly_salary,level_name: level,section_name: section, daily_Salary: (@teacher.monthly_salary.to_f / (Time.days_in_month Date.today.month)).round(2) }, status: :ok}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit(:name, :father, :education, :gender, :phone, :address, :cnic, :date_of_joining, :date_of_leaving, :yearly_increment, :monthly_salary, :school_branch_id, :section_id,:level_id)
    end
end
