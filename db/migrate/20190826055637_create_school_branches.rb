class CreateSchoolBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :school_branches do |t|
      t.string :name
      t.text :address
      t.string :code
      t.references :school, foreign_key: true

      t.timestamps
    end
  end
end
