# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::RatesController, type: :controller do
  let(:json_body) { Oj.load(response.body) }

  describe 'GET live' do
    before do
      now = Time.zone.now
      yesterday = now - 1.day

      @yesterday = Array.new(3) do
        create(:live_rate, live_timestamp: yesterday - rand(100).minutes)
      end

      @today = Array.new(5) do
        create(:live_rate, live_timestamp: now - rand(100).minutes)
      end.sort_by(&:live_timestamp)
    end

    describe 'returns data by date based on utc_offset' do
      it do
        utc_offset = @today.map(&:live_timestamp).min.utc_offset
        get :live, params: { utc_offset: utc_offset }
        expect(response).to be_successful
        expect(json_body.size).to eq(@today.count)
      end

      it do
        utc_offset = @yesterday.map(&:live_timestamp).min.utc_offset
        get :live, params: { utc_offset: utc_offset + (26.hours / 60) }
        expect(response).to be_successful
        expect(json_body.size).to eq(@today.count + @yesterday.count)
      end
    end
  end

  describe 'GET historical' do
    it 'requires `start_date` and `end_date` param' do
      expect do
        get :historical
      end.to raise_error(ActionController::ParameterMissing)

      expect do
        get :historical, params: { start_date: Date.today }
      end.to raise_error(ActionController::ParameterMissing)

      expect do
        get :historical, params: { end_date: Date.today }
      end.to raise_error(ActionController::ParameterMissing)
    end

    let(:start_date) { Date.parse('2019-02-10') }
    let(:end_date) { Date.parse('2019-02-12') }
    it 'returns 200 http response if start date is less than end date' do
      VCR.use_cassette("#{described_class}:historical:#{start_date}:#{end_date}") do
        get :historical, params: { start_date: start_date, end_date: end_date }
        expect(response).to be_successful
      end
    end
  end
end
