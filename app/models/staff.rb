class Staff < ApplicationRecord
  belongs_to :school_branch
  has_paper_trail only: [:monthly_salary]
  enum gender: %i[Male Female]
end
