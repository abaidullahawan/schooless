class ClassSection < ApplicationRecord
  belongs_to :level
  belongs_to :section

  def self.get_class_section_id(classId, sectionId, school_branchId)
    class_section = find_by(level_id: classId, section_id: sectionId)
    if class_section.blank?
      class_section = create(level_id: classId, section_id: sectionId, school_branch_id: school_branchId)
    end
    class_section.id
  end
end
