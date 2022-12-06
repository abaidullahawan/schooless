class CreateStaffs < ActiveRecord::Migration[5.0]
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :father
      t.string :education
      t.string :phone
      t.string :address
      t.string :cnic
      t.date :date_of_joining
      t.date :date_of_leaving
      t.integer :yearly_increment
      t.integer :monthly_salary

      t.timestamps
    end
  end
end
