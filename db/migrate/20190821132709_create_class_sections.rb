class CreateClassSections < ActiveRecord::Migration[5.0]
  def change
    create_table :class_sections do |t|
      t.references :level, foreign_key: true
      t.references :section, foreign_key: true

      t.timestamps
    end
  end
end
