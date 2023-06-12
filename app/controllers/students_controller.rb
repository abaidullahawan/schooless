class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy, :activate, :terminate, :pay_now]

  # GET /students
  # GET /students.json
  def index
    # if session[:school_branch_id].present? or session[:section_id] or session[:level_id].present?
      # params = ActionController::Parameters.new(q: { class_section_section_id_eq: session[:section_id], class_section_level_id_eq: session[:level_id],school_branch_id_eq: session[:school_branch_id]})
      # params.permitted?
    # else
      # params = ActionController::Parameters.new()
    # end
    response = HTTParty.get('http://sms4connect.com/api/sendsms.php/balance/status?id=essystem&pass=system65')
    puts response.body, response.code, response.message, response.headers.inspect
    hash = Hash.from_xml(response)
    # @api_balance = hash.first.last.first.last.pluck("response").map(&:to_i).sum
    @students_list_by_name=Student.where(deleted: false).distinct(:name)
    @students_list_by_fname=Student.where(deleted: false).distinct(:father_name)
    @q =  Student.where(deleted: false).distinct.ransack(params[:q])
    if @q.result.count>0
      @q.sorts = 'id asc' if @q.sorts.empty?
    end
    if params[:q].present?
      if params[:q][:name_cont].present?
        @name = params[:q][:name_cont]
      end
      if params[:q][:father_name_cont].present?
        @father = params[:q][:father_name_cont]
      end
      if params[:q][:school_branch_id_eq].present?
        @school_branch_id = params[:q][:school_branch_id_eq]
        session[:school_branch_id] = @school_branch_id
      else
        session[:school_branch_id]=''
      end
      if params[:q][:class_section_section_id_eq].present?
        @section_id = params[:q][:class_section_section_id_eq]
        session[:section_id] = @section_id
      else
        session[:section_id]=''
      end
      if params[:q][:class_section_level_id_eq].present?
        @level_id = params[:q][:class_section_level_id_eq]
        session[:level_id] = @level_id
      else
        session[:level_id]=''
      end
    end

    if (session[:school_branch_id].present? or session[:section_id] or session[:level_id].present?)
      if request.original_url.split('/s').last.length == 7
        # params = ActionController::Parameters.new(q: { class_section_section_id_eq: session[:section_id], class_section_level_id_eq: session[:level_id],school_branch_id_eq: session[:school_branch_id]})
        # params.permitted?
        params[:q]={class_section_section_id_eq: session[:section_id], class_section_level_id_eq: session[:level_id],school_branch_id_eq: session[:school_branch_id]}
        @q =  Student.where(deleted: false).distinct.ransack(params[:q])
      end
    end
    @students_sms = @q.result.joins(class_section: [:level, :section]).includes(class_section: [:level, :section])
    @students = @q.result.joins(class_section: [:level, :section]).includes(class_section: [:level, :section]).page(params[:page])
    @school_branches= SchoolBranch.where(school_id: current_user.school_id)

    session[:unpaid_students_ids] = @students.pluck(:id)

    #student fees
    st_ids = []
    @students_sms.each{|st| st_ids << st.id}
    @students_fees = StudentFee.where("extract(month from student_fees.paid_date) = ? AND extract(year from student_fees.paid_date) = ? AND student_fees.fee_type = ? AND student_id IN (?)", Date.today.month, Date.today.year, "Fee", st_ids)
    @total_paid=@students_fees.count()
    if params[:sms_all_eng].present? && params[:sms_msg].present?
      @sms_students = @students_sms.select{ |s| (s.phone_no!=nil or s.phone_no=="") and s.phone_no.length==12 }
      phone_no=@sms_students.pluck(:phone_no).uniq
      msg=URI::escape(params[:sms_msg])
      request='http://sms4connect.com/api/sendsms.php/sendsms/url?id=essystem&pass=system65&mask=ESS&to='+phone_no.join(',')+'923214459614'+'&lang=English&msg='+msg+'&type=xm'
      response = HTTParty.get(request)
      puts response.body, response.code, response.message, response.headers.inspect
      sms_forward=false
      if response.body.split("Message Sent to Telecom").length>1
        sms_forward=true
      end
    end

    if params[:sms_all_urdu].present? && params[:sms_msg].present?
      @sms_students = @students_sms.select{ |s| (s.phone_no!=nil or s.phone_no=="") and s.phone_no.length==12 }
      phone_no=@sms_students.pluck(:phone_no).uniq
      msg=URI::escape(params[:sms_msg])
      request='http://sms4connect.com/api/sendsms.php/sendsms/url?id=essystem&pass=system65&mask=ESS&to='+phone_no.join(',')+'923214459614'+'&lang=Urdu&msg='+msg+'&type=xm'
      response = HTTParty.get(request)
      puts response.body, response.code, response.message, response.headers.inspect
      sms_forward=false
      if response.body.split("Message Sent to Telecom").length>1
        sms_forward=true
      end
    end
    if params[:search_pdf].present?
      request.format = 'pdf'
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "student",
          layout: 'pdf.html',
          page_size: 'A4',
          title: "Student List",
          encoding: "UTF-8",
          show_as_html: false
        end
      end
    elsif params[:search_pdf_list].present?
      request.format = 'pdf'
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "student",
          layout: 'pdf.html',
          page_size: 'A4',
          title: "Student List",
          encoding: "UTF-8",
          show_as_html: false
        end
      end
    elsif params[:fee_list].present?
      request.format = 'pdf'
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "student",
          layout: 'pdf.html',
          page_size: 'A4',
          title: "Student List",
          encoding: "UTF-8",
          show_as_html: false
        end
      end
    else
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "student",
          layout: 'pdf.html',
          page_size: 'A4',
          title: "Student List",
          encoding: "UTF-8",
          show_as_html: true
        end
      end
    end

  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
    @students_list=Student.all
    # @student.student_fees.build
  end

  # GET /students/1/edit
  def edit
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
    @students_list=Student.all
    @student.student_fees.build
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)
    @student.class_section_id = ClassSection.get_class_section_id(params[:student][:class_id], params[:student][:section_id], params[:student][:school_branch_id])
    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        @school_branches = SchoolBranch.where(school_id: current_user.school_id)
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        @student.class_section_id = ClassSection.get_class_section_id(params[:student][:class_id], params[:student][:section_id], params[:student][:school_branch_id])
        @student.save!
        format.html { redirect_to students_url, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate
    @student.update(terminated: false)
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully activated.' }
      format.json { head :no_content }
    end
  end

  def terminate
    @student.update(terminated: true)
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully terminated.' }
      format.json { head :no_content }
    end
  end

  def pay_now
    @student.pay_fee_now
    redirect_to students_url, notice: "Student was successfully charged <strong>Rs. #{@student.monthly_fee} </strong> for <strong>#{Date.today.strftime('%B %Y')}</strong>"
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.update(deleted: true)
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :date_of_birth, :gender, :phone_no, :monthly_fee, :address, :class_section_id, :father_name, :balance, :school_branch_id,:admission,:admission_balance,:security,:security_balance,:paper_fund,:paper_fund_balance,:student_type,:phone_sec,
                                      :student_fees_attributes => [:id, :paid_date, :paid_fee, :fee_type, :student_id, :balance])
    end
end
