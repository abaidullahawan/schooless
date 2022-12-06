class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index
    if params[:expenses].present?
      @paid_to_month = params[:expenses][:month]
      @paid_to_year = params[:expenses][:year]
    else
      @paid_to_month = Date.today.month
      @paid_to_year = Date.today.year
    end
    @q = Expense.where("extract(month from created_at) = ? AND extract(year from created_at) = ?", @paid_to_month, @paid_to_year).ransack(params[:q])
    if @q.result.count > 0
      @q.sorts = 'id asc' if @q.sorts.empty?
    end
    if params[:q].present?
      @expense_type = params[:q][:expense_type_eq]
      @school_branch_id = params[:q][:school_branch_id_eq]
    end
    @expenses = @q.result(distinct: true).page(params[:page])
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  # GET /expenses/1/edit
  def edit
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:expense_type, :expense, :comment, :school_branch_id)
    end
end
