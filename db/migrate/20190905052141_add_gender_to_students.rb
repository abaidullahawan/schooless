class AddGenderToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :gender, :integer
    add_column :staffs, :gender, :integer
    add_column :teachers, :gender, :integer
  end
end
