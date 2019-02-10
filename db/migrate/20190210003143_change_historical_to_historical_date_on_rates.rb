class ChangeHistoricalToHistoricalDateOnRates < ActiveRecord::Migration[5.2]
  def change
    remove_column :rates, :historical, :boolean
    add_column :rates, :historical_date, :date
  end
end
