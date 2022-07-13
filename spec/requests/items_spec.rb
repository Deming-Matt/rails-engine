require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /index" do
    it 'sends a list of items' do
      get '/api/v1/items'

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(response).to be_successful

      items.each do |item|
        expect(item).to have_key(:data)
        expect(item[:data]).to be_a(Array)
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)

        expect(item[:attributes]).to_not have_key(:created_at)
      end
    end
  end
end
