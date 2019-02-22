# frozen_string_literal: true

RSpec.describe PagesController do
  describe 'GET #root' do
    it 'succeed' do
      get :root
      expect(response).to be_success
    end
  end
end
