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

  describe "GET show page" do
    it 'sends a merchant' do
      id = create(:merchant).id
      get "/api/v1/merchants/#{id}"

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(response).to be_successful
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes]).to_not have_key(:created_at)
    end
  end

  describe "GET merchants items" do
    it 'can send the Merchants items' do
      merchant = create(:merchant)
      id = merchant.id
      create_list(:item, 4, merchant: merchant)
      get "/api/v1/merchants/#{id}/items"

      response_body =JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(response).to be_successful
      expect(item[0]).to have_key(:id)
      expect(item[0]).to have_key(:attributes)
      expect(item[0][:attributes]).to have_key(:name)
      expect(item[0][:attributes]).to have_key(:description)
      expect(item[0][:attributes]).to have_key(:unit_price)
      expect(item[0]).to_not have_key(:created_at)
    end
  end
end
