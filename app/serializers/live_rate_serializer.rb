# frozen_string_literal: true

class LiveRateSerializer < Blueprinter::Base
  identifier :live_timestamp, name: :timestamp
  association :fetch_quotes, blueprint: QuoteSerializer, name: :quotes
end
