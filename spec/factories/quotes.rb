# frozen_string_literal: true
# == Schema Information
#
# Table name: quotes
#
#  id         :bigint(8)        not null, primary key
#  rate_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  iso_code   :string
#  rate_value :float
#

FactoryBot.define do
  factory :quote do
    rate { create %i[historical_rate live_rate].sample }
    iso_code { Quote::CURRENCIES.sample }
    rate_value { rand(10) }
  end
end
