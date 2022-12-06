class AddStudentTypeChargesToStudent < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :admission, :integer, default: 0
    add_column :students, :security, :integer, default: 0
    add_column :students, :paper_fund, :integer, default: 0
    add_column :students, :admission_balance, :integer, default: 0
    add_column :students, :security_balance, :integer, default: 0
    add_column :students, :paper_fund_balance, :integer, default: 0
    add_column :students, :student_type, :integer, default: 0
  end
end
