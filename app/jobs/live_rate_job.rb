# frozen_string_literal: true

# Responsible to fetch live rate and save it to Rate model
class LiveRateJob < ApplicationJob
  queue_as :default

  def perform
    api = RateApi.new
    live_rate = api.live
    timestamp = Time.zone.now
    return unless live_rate

    rate = Rate.create live_timestamp: timestamp
    quotes = live_rate['quotes']
    quotes.keys.each do |iso_code|
      Quote.create(rate: rate, rate_value: quotes[iso_code], iso_code: iso_code)
    end
  end
end
