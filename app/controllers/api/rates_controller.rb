# frozen_string_literal: true

module Api
  class RatesController < ::ApplicationController
    def historical
      dates = (params.require(:start_date).to_date..params.require(:end_date).to_date).to_a
      cache_keys = dates.map { |date| "#{self.class}:historical:#{date}" }
      return unless stale? CityHash.hash32([dates.first, dates.last, cache_keys]),
                           template: false

      data = Rails.cache.read_multi(*cache_keys)
      if data.keys.length != cache_keys.length
        missed_date = (cache_keys - data.keys).map do |ck|
          ck.split(':').last
        end

        Rate.where(historical_date: missed_date).each do |rate|
          cache_key = "#{self.class}:historical:#{rate.historical_date}"
          data[cache_key] = rate
          Rails.cache.write cache_key, rate
          missed_date -= [rate.historical_date]
        end

        api = RateApi.new
        api.historical(missed_date.map(&:to_date)).each do |api_data|
          next if api_data == false

          rate = Rate.create historical_date: api_data['date']
          quotes = api_data['quotes']
          quotes.keys.each do |iso_code|
            Quote.create(rate: rate, rate_value: quotes[iso_code], iso_code: iso_code)
          end
          cache_key = "#{self.class}:historical:#{api_data['date']}"
          data[cache_key] = rate
          Rails.cache.write cache_key, rate
        end
      end

      render json: HistoricalRateSerializer.render(data.values)
    end

    def live
      rates = Rate.where('DATE(live_timestamp) = ?', Date.today)
      return unless stale? rates.cache_key, template: false

      rates = rates.order(:live_timestamp)
      render json: LiveRateSerializer.render(rates)
    end
  end
end
