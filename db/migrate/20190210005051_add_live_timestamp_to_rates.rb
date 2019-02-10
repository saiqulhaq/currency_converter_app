class AddLiveTimestampToRates < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :live_timestamp, :datetime
  end
end
