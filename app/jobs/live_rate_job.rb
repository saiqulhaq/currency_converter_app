# frozen_string_literal: true
# Responsible to fetch live rate and save it to Rate model
class LiveRateJob < ApplicationJob
  queue_as(:default)
  API_KEY = Rails.application.credentials.one_forge_api_key
  def perform
    response = connection.get(path: "1.0.3/quotes?pairs=#{pairs}&api_key=#{API_KEY}")
    return unless response.status == 200
    quotes = Oj.load(response.body)
    rate = create_rate(quotes)
    create_quotes(rate, quotes)
  end

  def connection
    @connection ||= Excon.new("https://forex.1forge.com/", instrumentor: Excon::LoggingInstrumentor)
  end

  def pairs
    @pairs ||= begin
      pairs = Quote::CURRENCIES.dup
      pairs.shift
      pairs.map { |p|
        "#{p}USD"
      }.join(',')
    end
  end

  def create_rate(quotes)
    timestamp = Time.zone.at(quotes.first["timestamp"])
    Rate.create(live_timestamp: timestamp)
  end

  def create_quotes(rate, quotes)
    quotes.each do |quote|
      Quote.create(rate: rate, rate_value: quote["price"], iso_code: quote["symbol"].first(3))
    end

    Quote.create(rate: rate, rate_value: 1, iso_code: "USD")
  end
end
