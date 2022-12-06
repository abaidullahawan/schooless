module StudentsHelper
  def student_paid_this_month_fee?(student)
    @students_fees.find_by(student_id: student.id).present? if @students_fees.present?
  end
end
