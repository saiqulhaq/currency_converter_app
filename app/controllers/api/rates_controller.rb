# frozen_string_literal: true

module Api
  class RatesController < ::ApplicationController
    def historical
      dates = (params.require(:start_date).to_date..params.require(:end_date).to_date).to_a
      rates = Rate.where('historical_date between ? and ?', dates.first, dates.last)
      return unless stale? rates.cache_key, template: false

      rates = rates.order(:historical_date)
      render json: HistoricalRateSerializer.render(rates)
    end

    def live
      rates = Rate.where('DATE(live_timestamp) = ?', Date.today)
      return unless stale? rates.cache_key, template: false

      rates = rates.order(:live_timestamp)
      render json: LiveRateSerializer.render(rates)
    end
  end
end
