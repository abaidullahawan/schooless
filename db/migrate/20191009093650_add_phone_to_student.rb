class AddPhoneToStudent < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :phone_sec, :string
  end
end
