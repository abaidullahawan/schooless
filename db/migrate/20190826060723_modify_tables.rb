class ModifyTables < ActiveRecord::Migration[5.0]
  def change
    add_reference :sections, :school_branch, index: true
    add_reference :levels, :school_branch, index: true
    add_column :school_branches, :active, :boolean
    add_reference :class_sections, :school_branch, index: true
    add_reference :staffs, :school_branch, index: true
    add_reference :teachers, :school_branch, index: true
  end
end
