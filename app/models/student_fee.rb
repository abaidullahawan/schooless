class StudentFee < ApplicationRecord
  belongs_to :student, optional: true
end
