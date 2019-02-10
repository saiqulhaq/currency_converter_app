class AddIsoCodeAndRateValueToQuotes < ActiveRecord::Migration[5.2]
  def change
    add_column :quotes, :iso_code, :string, index: true
    add_column :quotes, :rate_value, :float
  end
end
