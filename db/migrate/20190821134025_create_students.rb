class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :name
      t.date :date_of_birth
      t.string :phone_no
      t.integer :monthly_fee
      t.text :address
      t.references :class_section, foreign_key: true

      t.timestamps
    end
  end
end
