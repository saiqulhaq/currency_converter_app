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

FactoryBot.define do
  factory :quote do
    rate { create %i[historical_rate live_rate].sample }
    price_cents { rand(1000) }
    price_currency { Quote::CURRENCIES.sample }
  end
end
