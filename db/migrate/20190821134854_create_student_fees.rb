class CreateStudentFees < ActiveRecord::Migration[5.0]
  def change
    create_table :student_fees do |t|
      t.date :paid_date
      t.integer :paid_fee
      t.integer :balance
      t.string :fee_type
      t.references :student, foreign_key: true

      t.timestamps
    end
  end
end
