class AddStaffIdToSalary < ActiveRecord::Migration[5.0]
  def change
    add_reference :salaries, :staff, foreign_key: true
  end
end
