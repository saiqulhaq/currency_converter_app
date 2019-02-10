require 'rails_helper'

RSpec.describe Api::RatesController, type: :controller do
  describe 'GET historical' do
    it do
      get :historical
      expect(response).to be_falsey
    end
  end

  describe 'GET live' do
    it do
      get :live
      expect(response).to be_falsey
    end
  end
end
