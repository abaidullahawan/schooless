class UpdateSchoolBranchToClassSection < ActiveRecord::Migration[5.0]
  def change
    ClassSection.all.each do |cs|
      cs.update(school_branch_id: cs.level.school_branch_id)
    end
  end
end
