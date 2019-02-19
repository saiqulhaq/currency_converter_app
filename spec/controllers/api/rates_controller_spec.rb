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

  xdescribe 'GET historical' do
    it do
      get :historical
      expect(response).to be_falsey
    end
  end
end
