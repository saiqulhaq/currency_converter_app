# frozen_string_literal: true
# == Schema Information
#
# Table name: quotes
#
#  id         :bigint(8)        not null, primary key
#  rate_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  iso_code   :string
#  rate_value :float
#

class Quote < ApplicationRecord
  include IdentityCache
  # supported currencies
  CURRENCIES = %w[USD BRL EUR AUD].freeze

  belongs_to :rate, inverse_of: :quotes
  cache_belongs_to :rate

  validates :iso_code, :rate_value, :rate_id, presence: true
end
