class AddAdvanceToTeacher < ActiveRecord::Migration[5.0]
  def change
    add_column :teachers, :advance_amount, :integer, default: 0
    add_column :staffs, :advance_amount, :integer, default: 0
  end
end
