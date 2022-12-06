class SchoolBranch < ApplicationRecord
  belongs_to :school
  has_many :levels
  has_many :sections
  has_many :staffs
  has_many :teachers
  has_many :class_sections
  has_many :students


  def self.update_status(school_id, branch_id=nil)
    where.not(id: branch_id).where(school_id: school_id).update_all(active: false) if branch_id.present?
    where(school_id: school_id).update_all(active: false) if branch_id.blank?
  end
end
