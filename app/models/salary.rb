class Salary < ApplicationRecord
  belongs_to :teacher, optional: true
  belongs_to :staff, optional: true
  belongs_to :school_branch

  enum paid_to: %i[Teacher Staff]
  enum payment_type: %i[Salary Advance]

  after_save :update_advance
  after_create :update_advance_to_zero


  def update_advance
    if self.Teacher?
      already_advance = teacher.advance_amount
      total_advance = already_advance.to_i + self.advance.to_i
      teacher.update(advance_amount: total_advance)
      update_columns(advance_due_till_this_transaction: total_advance)
    elsif self.Staff?
      already_advance = staff.advance_amount
      total_advance = already_advance.to_i + self.advance.to_i
      staff.update(advance_amount: total_advance)
      update_columns(advance_due_till_this_transaction: total_advance)
    end
  end

  def update_advance_to_zero
    if self.Salary?
      if self.Teacher?
        teacher.update(advance_amount: 0)
      elsif self.Staff?
        staff.update(advance_amount: 0)
      end
    end
  end
end
