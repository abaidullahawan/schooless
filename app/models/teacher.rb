class Teacher < ApplicationRecord
  belongs_to :school_branch
  belongs_to :level, optional: true
  belongs_to :section, optional: true
  # has_paper_trail only: [:monthly_salary]
  enum gender: %i[Male Female]
end
