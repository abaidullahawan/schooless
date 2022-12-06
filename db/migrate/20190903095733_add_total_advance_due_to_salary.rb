class AddTotalAdvanceDueToSalary < ActiveRecord::Migration[5.0]
  def change
    add_column :salaries, :advance_due_till_this_transaction, :integer, default: 0
  end
end
