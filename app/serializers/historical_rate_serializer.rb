# frozen_string_literal: true

class HistoricalRateSerializer < Blueprinter::Base
  identifier :historical_date, name: :date
  association :fetch_quotes, blueprint: QuoteSerializer, name: :quotes
end
