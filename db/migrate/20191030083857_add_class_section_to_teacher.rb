class AddClassSectionToTeacher < ActiveRecord::Migration[5.0]
  def change
    add_reference :teachers, :level, foreign_key: true
    add_reference :teachers, :section, foreign_key: true
  end
end
