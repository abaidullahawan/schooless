module TeachersHelper
  def teacher_paid_this_month_salary?(teacher)
    @teachers_pays.find_by(teacher_id: teacher.id).present? if @teachers_pays.present?
  end
end
