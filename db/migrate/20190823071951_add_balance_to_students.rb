class AddBalanceToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :father_name, :string
    add_column :students, :balance, :integer, default: 0
    remove_column :student_fees, :balance, :integer
  end
end
