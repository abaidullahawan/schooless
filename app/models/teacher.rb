class Teacher < ApplicationRecord
  belongs_to :school_branch
  belongs_to :level
  belongs_to :section
  has_paper_trail only: [:monthly_salary]
  enum gender: %i[Male Female]
end
