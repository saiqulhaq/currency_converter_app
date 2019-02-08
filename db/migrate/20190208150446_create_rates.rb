# frozen_string_literal: true

class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.date :date
      t.integer :hour
      t.boolean :historical, default: false

      t.timestamps
    end

    add_index :rates, :historical
    add_index :rates, %i[date hour], unique: true
  end
end
