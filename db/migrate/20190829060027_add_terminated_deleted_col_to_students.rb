class AddTerminatedDeletedColToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :terminated, :boolean, default: false
    add_column :students, :terminated_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :students, :deleted, :boolean, default: false
    add_column :students, :deleted_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
