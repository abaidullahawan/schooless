class AddPaymentTypeToSalary < ActiveRecord::Migration[5.0]
  def change
    add_column :salaries, :payment_type, :integer, default: "Salary"
  end
end
