class ReportsController < ApplicationController
  before_action :authenticate_user!, :active_branch
  def index
    @st_active = activated_list("Student").count
    @st_terminated = terminated_list("Student").count
    @st_deleted = deleted_list("Student").count

    @th_active = activated_list("Teacher").count
    @th_terminated = terminated_list("Teacher").count
    @th_deleted = deleted_list("Teacher").count

    @stf_active = activated_list("Staff").count
    @stf_terminated = terminated_list("Staff").count
    @stf_deleted = deleted_list("Staff").count

    if params[:q].present?
      @expense_type = params[:q][:expense_type_eq]
      @school_branch_id = params[:q][:school_branch_id_eq]
    end
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
    @students=Student.all.distinct.pluck(:phone_no)
  end

  def chart
    @paid_to_month = Date.today.month
    @paid_to_year = Date.today.year
    @total_fee_without = Student.where(:student_type=>0).sum(:monthly_fee)
    @collected_fee = StudentFee.where("extract(month from paid_date)=?",@paid_to_month).sum(:paid_fee)
    @expected_exp = Teacher.all.sum(:monthly_salary) + Staff.all.sum(:monthly_salary)
    @actual_exp = Salary.where("extract(month from created_at)=?",@paid_to_month).sum(:paid_salary)+Expense.where("extract(month from created_at)=?",@paid_to_month).sum(:expense)
    @revenue = Hash.new
    (1..12).each do |i|
      @paid_to_month == 0 ? @paid_to_month = 12 : @paid_to_month
      @revenue[Date::ABBR_MONTHNAMES[@paid_to_month]] = StudentFee.where("extract(month from paid_date)=?",@paid_to_month).sum(:paid_fee)
      @paid_to_month = @paid_to_month - 1
      @paid_to_month == 0 ? @paid_to_year = @paid_to_year-1 : @paid_to_year
    end

    @revenue = @revenue.to_a.reverse.to_h
    @paid_to_month = Date.today.month
    @paid_to_year = Date.today.year

    @expense=Hash.new
    (1..12).each do |i|
      @paid_to_month == 0 ? @paid_to_month = 12 : @paid_to_month
      @expense[Date::ABBR_MONTHNAMES[@paid_to_month]] = Salary.where("extract(month from created_at)=?",@paid_to_month).sum(:paid_salary)+Expense.where("extract(month from created_at)=?",@paid_to_month).sum(:expense)
      @paid_to_month = @paid_to_month - 1
      @paid_to_month == 0 ? @paid_to_year = @paid_to_year-1 : @paid_to_year
    end
    @paid_to_month = Date.today.month
    @paid_to_year = Date.today.year
    @expense_by_type=Hash.new
    (1..12).each do |i|
      @paid_to_month == 0 ? @paid_to_month = 12 : @paid_to_month
      @expense_by_type[Date::ABBR_MONTHNAMES[@paid_to_month]] = Salary.where("extract(month from created_at)=?",@paid_to_month).sum(:paid_salary),  Expense.where("extract(month from created_at)=?",@paid_to_month).group(:expense_type).sum(:expense)
      @paid_to_month = @paid_to_month - 1
      @paid_to_month == 0 ? @paid_to_year = @paid_to_year-1 : @paid_to_year
    end
    @paid_to_month = Date.today.month
    @paid_to_year = Date.today.year
    @revenue_by_type=Hash.new
    (1..12).each do |i|
      @paid_to_month == 0 ? @paid_to_month = 12 : @paid_to_month
      @revenue_by_type[Date::ABBR_MONTHNAMES[@paid_to_month]] = StudentFee.where("extract(month from paid_date)=?",@paid_to_month).group(:fee_type).sum(:paid_fee)
      @paid_to_month = @paid_to_month - 1
      @paid_to_month == 0 ? @paid_to_year = @paid_to_year-1 : @paid_to_year
    end

  end

  private

    def activated_list(model_name)
      @q = model_name.constantize.where(terminated: false, deleted: false).ransack(params[:q])
      @q.result(distinct: true)
    end

    def deleted_list(model_name)
      @q = model_name.constantize.where(deleted: true).ransack(params[:q])
      @q.result(distinct: true)
    end

    def terminated_list(model_name)
      @q = model_name.constantize.where(terminated: true).ransack(params[:q])
      @q.result(distinct: true)
    end
end
