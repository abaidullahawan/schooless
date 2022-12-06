class Widow < ApplicationRecord
  before_update :create_expense
  def create_expense
    if self.paid==true
      Expense.create(:expense_type=>"Widows Aids program",:expense=>self.monthly_aid,:comment=>self.name.to_s+" | Paid Date: "+Date.today.to_s,:school_branch_id=>1)
    end
  end
end
