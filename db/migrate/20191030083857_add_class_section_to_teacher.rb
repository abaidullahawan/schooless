class AddClassSectionToTeacher < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!

  def up
    change_table :teachers do |t|
      t.references :level, index: true, null: true
      t.references :section, index: true, null: true
    end
  end

  def down
    change_table :teachers do |t|
      t.remove_references :level, index: true, null: true
      t.remove_references :section, index: true, null: true
    end
  end
end
