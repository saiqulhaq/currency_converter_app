# frozen_string_literal: true

class HistoricalRateSerializer < Blueprinter::Base
  identifier :historical_date, name: :date
  association :quotes, blueprint: QuoteSerializer
end
