class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.string :expense_type
      t.integer :expense
      t.text :comment
      t.references :school_branch, foreign_key: true

      t.timestamps
    end
  end
end
