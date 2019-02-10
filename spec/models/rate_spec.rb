# == Schema Information
#
# Table name: rates
#
#  id              :bigint(8)        not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  historical_date :date
#  live_timestamp  :datetime
#

require 'rails_helper'

RSpec.describe Rate, type: :model do
  let(:historical_rate) { create(:rate, historical_date: Date.yesterday) }
  let(:live_rate) { create(:rate, live_timestamp: 3.minutes.ago) }

  describe '#historical?' do
    it 'returns true if historical_date is present' do
      expect(historical_rate.historical?).to be_truthy
      expect(live_rate.historical?).to be_falsey
    end
  end

  describe '#live?' do
    it 'returns true if live_timestamp is present' do
      expect(live_rate.live?).to be_truthy
      expect(historical_rate.live?).to be_falsey
    end
  end

  describe '#valid?' do
    it 'returns false if both `historical_date` and `live_timestamp` are present' do
      instance = described_class.new historical_date: Date.yesterday, live_timestamp: 10.minutes.ago
      expect(instance.valid?).to be_falsey
      instance.historical_date = nil
      expect(instance.valid?).to be_truthy
    end

    it 'returns false if both `historical_date` and `live_timestamp` are empty' do
      instance = described_class.new
      expect(instance.valid?).to be_falsey
    end
  end

  it 'should has many quotes' do
    instance = described_class.new
    expect(instance).to respond_to(:quotes)
    expect(instance.quotes).to be_a(ActiveRecord::Associations::CollectionProxy)
  end
end
