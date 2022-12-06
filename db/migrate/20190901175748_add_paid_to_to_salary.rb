class AddPaidToToSalary < ActiveRecord::Migration[5.0]
  def change
    add_column :salaries, :paid_to, :integer
  end
end
