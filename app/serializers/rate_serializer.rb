# frozen_string_literal: true

class RateSerializer < Blueprinter::Base
  view :live do
    identifier :live_timestamp, name: :timestamp
    include_view :quotes_association
  end

  view :quotes_association do
    association :quotes, blueprint: QuoteSerializer
  end
end
