require 'rails_helper'

RSpec.describe "Merchants", type: :request do
  describe "GET /index" do
    it 'sends a list of merchants' do
      get '/api/v1/merchants'

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchants = response_body[:data]

      expect(response).to be_successful

      merchants.each do |merchant|
        expect(merchant).to have_key(:data)

        expect(merchant).to have_key(:id)
        expect(merchant).to be_an(Integer)

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to have_key(:name)

        expect(merchant[:attributes]).to_not have_key(:created_at)
      end
    end
  end
end
