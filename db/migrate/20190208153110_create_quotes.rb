class CreateQuotes < ActiveRecord::Migration[5.2]
  def change
    create_table :quotes do |t|
      t.references :rate, foreign_key: true
      t.monetize :price
      t.timestamps
    end
  end
end
