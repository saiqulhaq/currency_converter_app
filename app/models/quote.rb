# frozen_string_literal: true
# == Schema Information
#
# Table name: quotes
#
#  id             :bigint(8)        not null, primary key
#  rate_id        :bigint(8)
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Quote < ApplicationRecord
  # supported currencies
  CURRENCIES = %w[USD BRL EUR AUD].freeze

  belongs_to :rate
  monetize :price_cents
end
