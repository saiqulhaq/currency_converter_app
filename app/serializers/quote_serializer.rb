# frozen_string_literal: true

class QuoteSerializer < Blueprinter::Base
  identifier :iso_code, name: :iso
  field :rate_value, name: :rate
end
