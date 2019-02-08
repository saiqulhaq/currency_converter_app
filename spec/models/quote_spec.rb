# == Schema Information
#
# Table name: quotes
#
#  id             :bigint(8)        not null, primary key
#  rate_id        :bigint(8)
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:quote) { create(:quote) }
  it 'belongs to rate' do
    expect(quote).to respond_to(:rate)
    expect(quote.rate).to be_a(Rate)
  end

  it { is_expected.to monetize(:price) }
end
