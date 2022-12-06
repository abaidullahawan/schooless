class Section < ApplicationRecord
  belongs_to :school_branch
  has_one :class_section
  has_one :level, through: :class_section
end
