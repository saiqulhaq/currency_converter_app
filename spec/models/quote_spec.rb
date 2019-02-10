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

require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:quote) { create(:quote) }
  it 'belongs to rate' do
    expect(quote).to respond_to(:rate)
    expect(quote.rate).to be_a(Rate)
  end

  it 'validates presence of iso_code, rate_value and parent rate' do
    expect(subject.valid?).to be_falsey

    subject.iso_code = 'USD'
    expect(subject.valid?).to be_falsey

    subject.rate_value = 0.123
    expect(subject.valid?).to be_falsey

    subject.rate = create(:live_rate)
    expect(subject.valid?).to be_truthy
  end
end
