require 'rails_helper'

RSpec.describe LiveRateJob, type: :job do
  describe '#perform' do
    it 'fetch live rate data and save it to db' do
      VCR.use_cassette("#{described_class}_perform") do
        expect do
          expect { subject.perform }.to change(Rate, :count).by(1)
        end.to change(Quote, :count).by(Quote::CURRENCIES.count)
      end
    end
  end
end
