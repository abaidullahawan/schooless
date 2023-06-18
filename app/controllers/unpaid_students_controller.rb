class UnpaidStudentsController < ApplicationController
  before_action :authenticate_user!, :active_branch
  require 'net/http'
  require 'rexml/document'
  def index
    response = HTTParty.get('http://sms4connect.com/api/sendsms.php/balance/status?id=essystem&pass=system65')
    puts response.body, response.code, response.message, response.headers.inspect
    hash = Hash.from_xml(response)
    # @api_balance = hash.first.last.first.last.pluck("response").map(&:to_i).sum
    if params[:unpaid_student].present?
      @paid_to_month = params[:unpaid_student][:month]
      @paid_to_year = params[:unpaid_student][:year]
    else
      @paid_to_month = Date.today.month
      @paid_to_year = Date.today.year
    end
    paid_students = StudentFee.where("extract(month from student_fees.paid_date) = ? AND extract(year from student_fees.paid_date) = ? AND student_fees.fee_type = ?", @paid_to_month, @paid_to_year, "Fee")
    @q = Student.where.not(id: paid_students.pluck(:student_id)).where("deleted=false AND student_type = ?", 0).ransack(params[:q])

    @aps_count=Student.where("deleted=false AND admission_balance < 0 OR security_balance < 0 OR paper_fund_balance < 0").count()
    if @q.result.count > 0
      @q.sorts = 'id asc' if @q.sorts.empty?
    end
    if params[:q].present?
      @name = params[:q][:name_cont]
      @father = params[:q][:father_name_cont]
      @school_branch_id = params[:q][:school_branch_id_eq]
      @level_id = params[:q][:class_section_level_id_eq]
      @section_id = params[:q][:class_section_section_id_eq]
    end

    @students = @q.result(distinct: true).page(params[:page])
    @student_list = @q.result(distinct: true)
    @p=Student.where("deleted=false AND student_type = ? OR admission_balance < 0 OR security_balance < 0 OR paper_fund_balance < 0", 0)
    @aps_balance_students=@p-@students

    session[:unpaid_students_ids] = @students.pluck(:id)
    session[:unpaid_students_search_date] = "01-#{@paid_to_month}-#{@paid_to_year}"
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)

    if params[:sms_all_eng].present? && params[:sms_msg].present?
      @sms_students = @student_list.select{ |s| (s.phone_no!=nil or s.phone_no=="") and s.phone_no.length==12 }
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
      @sms_students = @student_list.select{ |s| (s.phone_no!=nil or s.phone_no=="") and s.phone_no.length==12 }
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
  end

  def unpaid_funds_students
    if params[:unpaid_student].present?
      @paid_to_month = params[:unpaid_student][:month]
      @paid_to_year = params[:unpaid_student][:year]
    else
      @paid_to_month = Date.today.month
      @paid_to_year = Date.today.year
    end
    @q = Student.where("deleted=false AND student_type = 0 AND (admission_balance < 0 OR security_balance < 0 OR paper_fund_balance < 0)").ransack(params[:q])
    if @q.result.count > 0
      @q.sorts = 'id asc' if @q.sorts.empty?
    end
    if params[:q].present?
      @name = params[:q][:name_cont]
      @father = params[:q][:father_name_cont]
      @school_branch_id = params[:q][:school_branch_id_eq]
      @level_id = params[:q][:class_section_level_id_eq]
      @section_id = params[:q][:class_section_section_id_eq]
    end
    @students = @q.result(distinct: true).page(params[:page])
    session[:unpaid_students_ids] = @students.pluck(:id)
    session[:unpaid_students_search_date] = "01-#{@paid_to_month}-#{@paid_to_year}"
    @school_branches = SchoolBranch.where(school_id: current_user.school_id)
  end

  def pay_now
    @student = Student.find_by(id: params[:id])
    pay_date = params[:pay_date]
    @student.pay_fee_now(pay_date)
    redirect_to unpaid_students_url, notice: "Student was successfully charged <strong>Rs. #{@student.monthly_fee} </strong> for #{pay_date.to_date.strftime('%B %Y')}"
  end

  def sms_to_student
    @student = Student.find_by(id: params[:id])
    if @student.phone_no.present? and @student.phone_no.length==12
      msg=URI::escape("Dear Parents,\nReminder of Fee.We request you to please deposit the school fee.\nFine After Due Date:200\nPrincipal,\nEducational School System")
      request='http://sms4connect.com/api/sendsms.php/sendsms/url?id=essystem&pass=system65&mask=ESS&to='+@student.phone_no+',923214459614'+'&lang=English&msg='+msg+'&type=xm'
      response = HTTParty.get(request)
      puts response.body, response.code, response.message, response.headers.inspect
      sms_forward=false
      if response.body.split("Message Sent to Telecom").length>1
        sms_forward=true
      end
    end
  end

  def sms_to_all_student
    unpaid_students_ids = session[:unpaid_students_ids]
    unpaid_students_search_date = session[:unpaid_students_search_date]
    @students = Student.where(id: unpaid_students_ids)
    phone_no=@students.select{ |s| s.phone_no!=nil and s.phone_no.length==12 }.pluck(:phone_no)
    msg=URI::escape("Dear Parents,\nReminder of Fee.We request you to please deposit the school fee.\nFine After Due Date:200\nPrincipal,\nEducational School System")
    request='http://sms4connect.com/api/sendsms.php/sendsms/url?id=essystem&pass=system65&mask=ESS&to='+phone_no.join(',')+'923214459614'+'&lang=English&msg='+msg+'&type=xm'
    puts request
    response = HTTParty.get(request)
    puts response.body, response.code, response.message, response.headers.inspect
    sms_forward=false
    if response.body.split("Message Sent to Telecom").length>1
      sms_forward=true
    end
  end

  def print
    print_fee('A8', true)
  end

  def print_fee_challan
    print_fee('A4', true)
  end

  def deserving_student_list
    @students = Student.where(student_type: [1,2],deleted: false)
    @fee=@students.sum(:monthly_fee)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Deserving-Student-List",
        layout: 'pdf.html',
        page_size: 'A4',
        margin_top: '0',
        margin_right: '0',
        margin_bottom: '0',
        margin_left: '0',
        encoding: "UTF-8",
        show_as_html: false
      end
    end
  end

  def student_list
    @students=Student.where(deleted: false)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "student-list",
        layout: 'pdf.html',
        page_size: 'A4',
        margin_top: '0',
        margin_right: '0',
        margin_bottom: '0',
        margin_left: '0',
        encoding: "UTF-8",
        show_as_html: false
      end
    end
  end

  def active_student_list
    @students=Student.where(deleted: false)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "student-list",
        layout: 'pdf.html',
        page_size: 'A4',
        margin_top: '0',
        margin_right: '0',
        margin_bottom: '0',
        margin_left: '0',
        encoding: "UTF-8",
        show_as_html: false
      end
    end
  end

  def print_all
    print_all_fees('A8', true)
  end

  def print_all_fee_challan
    print_all_fees('A4', true)
  end

  def print_for_all
    @paid_to_month = Date.today.month
    @paid_to_year = Date.today.year
    unpaid_students_ids = session[:unpaid_students_ids]
    unpaid_students_search_date = "01-#{@paid_to_month}-#{@paid_to_year}"
    @students = Student.where(id: unpaid_students_ids).where(student_type: 0)
    pay_date = unpaid_students_search_date.to_date

    @fee_due_month = "#{pay_date.strftime('%d %B %Y')}"

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Un-paid-students",
        layout: 'pdf.html',
        page_size: 'A8',
        show_as_html: true
      end
    end
  end

  def print_all_without_balance
    unpaid_students_ids = session[:unpaid_students_ids]
    unpaid_students_search_date = session[:unpaid_students_search_date]
    @students = Student.where(id: unpaid_students_ids)
    pay_date = unpaid_students_search_date.to_date
    @fee_due_month = "#{pay_date.strftime('%d %B %Y')}"

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Un-paid-students",
        layout: 'pdf.html',
        page_size: 'A8',
        show_as_html: true
      end
    end
  end

  private

  def print_fee(page_size, show_as_html)
    @student = Student.find_by(id: params[:id])
    unpaid_students_search_date = session[:unpaid_students_search_date]
    pay_date = unpaid_students_search_date.to_date
    @fee_due_month = pay_date.strftime('%d %B %Y').to_s

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Student-List",
        layout: 'pdf.html',
        page_size: page_size,
        margin_top: '0',
        margin_right: '0',
        margin_bottom: '0',
        margin_left: '0',
        encoding: "UTF-8",
        show_as_html: show_as_html
      end
    end
  end

  def print_all_fees(page_size, show_as_html)
    unpaid_students_ids = session[:unpaid_students_ids]
    unpaid_students_search_date = session[:unpaid_students_search_date]
    @students = Student.where(id: unpaid_students_ids)
    pay_date = unpaid_students_search_date.to_date
    @fee_due_month = "#{pay_date.strftime('%d %B %Y')}"

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Un-paid-students",
        layout: 'pdf.html',
        page_size: page_size,
        show_as_html: show_as_html
      end
    end
  end
end
