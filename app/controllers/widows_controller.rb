class WidowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_widow, only: [:show, :edit, :update, :destroy, :pay_now]

  # GET /widows
  # GET /widows.json
  def index
    @total=Widow.sum(:monthly_aid)
    @total_paid=Widow.where(:paid=>true).sum(:monthly_aid)
    @q = Widow.ransack(params[:q])
    if @q.result.count > 0
      @q.sorts = 'id asc' if @q.sorts.empty?
    end
    @widows = @q.result(distinct: true).page(params[:page])
  end

  # GET /widows/1
  # GET /widows/1.json
  def show
  end

  # GET /widows/new
  def new
    @widow = Widow.new
  end

  # GET /widows/1/edit
  def edit
  end

  # POST /widows
  # POST /widows.json
  def create
    @widow = Widow.new(widow_params)

    respond_to do |format|
      if @widow.save
        format.html { redirect_to @widow, notice: 'Widow was successfully created.' }
        format.json { render :show, status: :created, location: @widow }
      else
        format.html { render :new }
        format.json { render json: @widow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /widows/1
  # PATCH/PUT /widows/1.json
  def update
    respond_to do |format|
      if @widow.update(widow_params)
        format.html { redirect_to @widow, notice: 'Widow was successfully updated.' }
        format.json { render :show, status: :ok, location: @widow }
      else
        format.html { render :edit }
        format.json { render json: @widow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /widows/1
  # DELETE /widows/1.json
  def destroy
    @widow.destroy
    respond_to do |format|
      format.html { redirect_to widows_url, notice: 'Widow was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pay_now
    @widow.update(:paid=>true)
    redirect_to widows_url, notice: "Widiw was successfully Paid <strong>Rs. #{@widow.monthly_aid} </strong> for <strong>#{Date.today.strftime('%B %Y')}</strong>"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_widow
      @widow = Widow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def widow_params
      params.require(:widow).permit(:name, :monthly_aid, :comment)
    end
end
