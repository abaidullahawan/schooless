class CreateSalaries < ActiveRecord::Migration[5.0]
  def change
    create_table :salaries do |t|
      t.integer :paid_salary
      t.integer :advance, default: 0
      t.integer :leaves_in_month, default: 0
      t.references :teacher, foreign_key: true
      t.references :school_branch, foreign_key: true

      t.timestamps
    end
  end
end
