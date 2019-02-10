class RemoveDateAndHourFromRates < ActiveRecord::Migration[5.2]
  def change
    remove_column :rates, :date, :date
    remove_column :rates, :hour, :integer
  end
end
