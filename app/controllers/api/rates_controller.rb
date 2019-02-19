# frozen_string_literal: true

module Api
  class RatesController < ::ApplicationController
    def historical
      dates = (params.require(:start_date).to_date..params.require(:end_date).to_date).to_a
      return unless stale? CityHash.hash32([dates.first, dates.last]), template: false

      rates = FetchHistoricalRate.new
      render json: HistoricalRateSerializer.render(rates.perform(dates))
    end

    def live
      timestamp = Time.zone.now - params.require(:utc_offset).to_i.minutes - 24.hours
      rates = Rate.where('live_timestamp >= ?', timestamp)
      return unless stale? rates.cache_key, template: false

      rates = rates.order(:live_timestamp)
      render json: LiveRateSerializer.render(rates)
    end
  end
end
