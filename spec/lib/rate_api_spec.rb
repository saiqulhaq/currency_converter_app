# frozen_string_literal: true

require 'rails_helper'
require_dependency 'rate_api'

RSpec.fdescribe RateApi do
  let(:instance) { described_class.new }

  describe '#live' do
    it 'returns `source` and `quotes` data' do
      VCR.use_cassette("#{described_class}_live") do
        live = subject.live
        expect(live).to have_key('source')
        expect(live).to have_key('quotes')
        Quote::CURRENCIES.each do |currency|
          expect(live['quotes']).to have_key(currency)
        end
      end
    end
  end

  describe '#historical' do
    let(:current_date) { Date.parse('2019-02-09') }

    context '`date` param' do
      it 'returns `source` and `quotes` data if date is current date' do
        VCR.use_cassette("#{described_class}_historical_current_date") do
          historical = subject.historical(current_date)
          expect(historical).to have_key('source')
          expect(historical).to have_key('quotes')
          Quote::CURRENCIES.each do |currency|
            expect(historical['quotes']).to have_key(currency)
          end
        end
      end

      it 'returns `source` and `quotes` object if date is past date' do
        VCR.use_cassette("#{described_class}_historical_past_date") do
          historical = subject.historical(Date.parse('2019-02-08'))
          expect(historical).to have_key('source')
          expect(historical).to have_key('quotes')
          Quote::CURRENCIES.each do |currency|
            expect(historical['quotes']).to have_key(currency)
          end
        end
      end

      context 'date value is a future date' do
        subject { described_class.new.historical(Date.tomorrow) }
        it 'returns false' do
          expect(subject).to be_falsey
        end

        it "returns 'date should be past or current' errors message" do
          instance.historical(Date.tomorrow)
          expect(instance.error_message).to eq('date should be past or current')
        end
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
