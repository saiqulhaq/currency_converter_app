# frozen_string_literal: true

require 'rails_helper'
require_dependency 'currency_layer'

RSpec.describe CurrencyLayer do
  let(:instance) { described_class.new }

  describe '#historical' do
    let(:dates_param) do
      [Date.parse('2019-02-09'),
       Date.parse('2019-02-08'),
       Date.parse('2019-02-07')]
    end

    context '`dates` param' do
      it 'returns array, same as given dates param given' do
        VCR.use_cassette("#{described_class}_historical_multiple") do
          historical = subject.historical(dates_param)
          expect(historical.size).to eq(dates_param.length)
        end

        VCR.use_cassette("#{described_class}_historical_single") do
          historical = subject.historical([dates_param.first])
          expect(historical.size).to eq(1)
        end
      end

      it 'returns `date`, `source` and `quotes` data if date is current date' do
        VCR.use_cassette("#{described_class}_historical_multiple") do
          historical = subject.historical(dates_param)[0]
          expect(historical).to have_key('date')
          expect(historical).to have_key('source')
          expect(historical).to have_key('quotes')
          Quote::CURRENCIES.each do |currency|
            expect(historical['quotes']).to have_key(currency)
          end
        end
      end

      context 'date value is a future date' do
        subject { described_class.new.historical([Date.tomorrow]) }
        it 'is okay' do
          instance.historical([Date.tomorrow])
          expect(instance.error_message).to be_blank
        end
      end
    end

    it "returns 'sorry we have limited resource' error message if api limit exceeded" do
      allow(instance).to receive(:exec_api_request).and_return(nil)
      allow(instance).to receive(:success_api_request?).and_return(false)
      allow(instance).to receive(:api_response_error_code).and_return(104)

      instance.historical([Date.today])
      message = 'sorry we have limited resource'
      expect(instance.error_message).to eq(message)
    end
  end
end
