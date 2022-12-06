class AddBalanceToStudentFees < ActiveRecord::Migration[5.0]
  def change
    add_column :student_fees, :balance, :integer, default: 0
  end
end
