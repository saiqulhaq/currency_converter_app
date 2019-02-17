# frozen_string_literal: true

class LiveRateSerializer < Blueprinter::Base
  identifier :live_timestamp, name: :timestamp
  association :quotes, blueprint: QuoteSerializer
end
