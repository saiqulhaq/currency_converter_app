# frozen_string_literal: true
# == Schema Information
#
# Table name: rates
#
#  id              :bigint(8)        not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  historical_date :date
#  live_timestamp  :datetime
#

FactoryBot.define do
  factory :rate do
    factory :historical_rate do
      historical_date { rand(100).days.ago }
    end
    factory :live_rate do
      live_timestamp { rand(60).minutes.ago }
    end
  end
end
