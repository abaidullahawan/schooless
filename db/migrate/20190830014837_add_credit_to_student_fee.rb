class AddCreditToStudentFee < ActiveRecord::Migration[5.0]
  def change
    add_column :student_fees, :credit, :integer, default: 0
  end
end
