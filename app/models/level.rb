class Level < ApplicationRecord
  belongs_to :school_branch
  has_many :class_sections
  has_many :sections, through: :class_sections
end
