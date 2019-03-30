# frozen_string_literal: true

# Fetch from cache, find from db or request rate data from currencylayer
class FetchHistoricalRate
  def perform(dates)
    existing_data = find_existing_caches(dates)
    return existing_data.values unless stale?

    data = create_or_find_data(existing_data)

    return [] if errors.present?

    data.values
  end

  def errors
    @errors ||= ActiveSupport::Error.new(self)
  end

  private

  attr_accessor :cache_keys

  def stale?
    @stale == true
  end

  def find_existing_caches(dates)
    self.cache_keys = dates.map { |date| "#{self.class}:historical:#{date}" }
    data = Rails.cache.read_multi(*cache_keys)
    @stale = data.keys.length == cache_keys.length
    data
  end

  def create_or_find_data(data)
    missed_date = (cache_keys - data.keys).map do |ck|
      ck.split(':').last
    end

    populate_based_on_db(data, missed_date)
    request_new_data(data, missed_date) if missed_date.present?
    data
  end

  def populate_based_on_db(data, missed_date)
    Rate.where(historical_date: missed_date).each do |rate|
      cache_key = "#{self.class}:historical:#{rate.historical_date}"
      data[cache_key] = rate
      Rails.cache.write cache_key, rate
      missed_date -= [rate.historical_date]
    end
  end

  def request_new_data(data, missed_date)
    api = CurrencyLayer.new
    api.historical(missed_date.map(&:to_date)).each do |api_data|
      next if api_data == false

      rate = create_rate(api_data)
      cache_key = "#{self.class}:historical:#{api_data['date']}"
      data[cache_key] = rate
      Rails.cache.write cache_key, rate
    end
  end

  def create_rate(api_data)
    rate = Rate.find_or_create_by historical_date: api_data['date']
    quotes = api_data['quotes']
    quotes = quotes.keys.map do |iso_code|
      { rate: rate, rate_value: quotes[iso_code], iso_code: iso_code }
    end
    Quote.create(quotes)
    rate
  end
end
