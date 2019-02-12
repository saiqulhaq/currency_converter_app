# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::RatesController, type: :controller do
  let(:json_body) { Oj.load(response.body) }

  describe 'GET live' do
    before do
      yesterday = 1.day.ago
      @yesterday = Array.new(3) do
        create(:live_rate, live_timestamp: yesterday - rand(100).minutes)
      end

      now = Time.zone.now
      @today = Array.new(5) do
        create(:live_rate, live_timestamp: now - rand(100).minutes)
      end.sort_by(&:live_timestamp)
    end
    it 'returns today live rate data' do
      get :live
      expect(response).to be_successful
      expect(json_body.size).to eq(@today.count)
    end
  end

  xdescribe 'GET historical' do
    it do
      get :historical
      expect(response).to be_falsey
    end
  end
end
