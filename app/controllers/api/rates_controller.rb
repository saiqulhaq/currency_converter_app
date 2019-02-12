# frozen_string_literal: true

module Api
  class RatesController < ::ApplicationController
    def historical
      return render json: 'invalid date' if date_param.nil?

      cache_key = "#{self.class}:historical:#{date_param}"
      json = Rails.cache.fetch(cache_key) do
        api.historical(date_param)
      end
      render json: json
    end

    def live
      return unless stale?

      rates = Rate.where('DATE(live_timestamp) = ?', Date.today)
                  .order(:live_timestamp)
      render json: RateSerializer.render(rates, view: :live)
    end

    private

    def api
      @api ||= RateApi.new
    end

    def date_param
      return @date_param if defined?(@date_param)

      @date_param = begin
                      Date.parse params.require(:date)
                    rescue ArgumentError
                      nil
                    end
    end
  end
end
