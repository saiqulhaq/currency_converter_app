class RemoveMoneyFromQuote < ActiveRecord::Migration[5.2]
  def change
    remove_monetize :quotes, :price
  end
end
