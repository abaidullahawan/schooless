class AddPaidToWidow < ActiveRecord::Migration[5.0]
  def change
    add_column :widows, :paid, :boolean
  end
end
