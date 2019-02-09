# frozen_string_literal: true

require 'rails_helper'
require_dependency 'rate_api'

RSpec.fdescribe RateApi do
  let(:instance) { described_class.new }

  describe '#historical' do
    it 'returns Rate object if date is current date' do
      VCR.use_cassette("#{described_class}_historical_current_date") do
        historical = subject.historical(Date.parse('2019-02-09'))
        expect(historical).to have_key('source')
        expect(historical).to have_key('quotes')
        Quote::CURRENCIES.each do |currency|
          expect(historical['quotes']).to have_key(currency)
        end
      end
    end

    it 'returns Rate object if date is past date' do
      VCR.use_cassette("#{described_class}_historical_past_date") do
        historical = subject.historical(Date.parse('2019-02-08'))
        expect(historical).to have_key('source')
        expect(historical).to have_key('quotes')
        Quote::CURRENCIES.each do |currency|
          expect(historical['quotes']).to have_key(currency)
        end
      end
    end

    context 'date is future date' do
      subject { described_class.new.historical(Date.tomorrow) }
      it 'returns false' do
        expect(subject).to be_falsey
      end

      it "returns 'date should be past or current' errors message" do
        instance.historical(Date.tomorrow)
        expect(instance.error_message).to eq('date should be past or current')
      end
    end

    it "returns 'sorry we have limited resource' error message if api limit exceeded" do
      allow(instance).to receive(:exec_api_request).and_return(nil)
      allow(instance).to receive(:success_api_request?).and_return(false)
      allow(instance).to receive(:api_response_error_code).and_return(104)

      instance.historical(Date.today)
      message = 'sorry we have limited resource'
      expect(instance.error_message).to eq(message)
    end
  end
end
