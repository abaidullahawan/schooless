class CreateWidows < ActiveRecord::Migration[5.0]
  def change
    create_table :widows do |t|
      t.string :name
      t.integer :monthly_aid
      t.text :comment

      t.timestamps
    end
  end
end
