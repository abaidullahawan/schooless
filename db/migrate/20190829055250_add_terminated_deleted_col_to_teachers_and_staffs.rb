class AddTerminatedDeletedColToTeachersAndStaffs < ActiveRecord::Migration[5.0]
  def change
    add_column :teachers, :terminated, :boolean, default: false
    add_column :teachers, :terminated_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :teachers, :deleted, :boolean, default: false
    add_column :teachers, :deleted_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }

    add_column :staffs, :terminated, :boolean, default: false
    add_column :staffs, :terminated_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :staffs, :deleted, :boolean, default: false
    add_column :staffs, :deleted_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
