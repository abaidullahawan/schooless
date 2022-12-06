class UpdateColumnsName < ActiveRecord::Migration[5.0]
  def change
    rename_column :teachers, :dof, :date_of_joining
    rename_column :teachers, :dol, :date_of_leaving
    rename_column :teachers, :yincrement, :yearly_increment
    rename_column :teachers, :salary, :monthly_salary

    rename_column :staffs, :doj, :date_of_joining
    rename_column :staffs, :dol, :date_of_leaving
    rename_column :staffs, :yincrement, :yearly_increment
    rename_column :staffs, :monthlysalary, :monthly_salary
  end
end
