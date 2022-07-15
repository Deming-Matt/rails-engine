require 'rails_helper'

RSpec.describe "Merchants", type: :request do
  describe "GET /index" do
    it 'sends a list of merchants' do
      create_list(:merchant, 5)
      get '/api/v1/merchants'

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchants = response_body[:data]

      expect(response).to be_successful

      merchants.each do |merchant|
        expect(response_body).to have_key(:data)

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(Integer)

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

    # xit 'can return a status 404 code' do
    #   merchant = create(:merchant)
    #   id = merchant.id + 1
    #   create_list(:item, 4, merchant: merchant)
    #   get "/api/v1/merchants/#{id}/items"
    # end
  end

  describe "GET /find"
    it 'can find a merchant by name' do
      # params = {name: "Crazy Carl's"}
      merchant = Merchant.create!({name: "Crazy Carl's"})
      merchant = Merchant.create!({name: "Pizza Crazy"})
      create_list(:merchant, 6)
      query_params = "?name=CrAzY"
      get "/api/v1/merchants/find#{query_params}"

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchants = response_body[:data]

      expect(response).to be_successful
      expect(merchants).to be_a(Hash)
      expect(merchants).to have_key(:attributes)
      expect(merchants[:attributes]).to have_key(:name)
      expect(merchants[:attributes][:name]).to eq("Crazy Carl's")
    end

    it 'sad path - should be empty object' do
      merchant = Merchant.create!({name: "Crazy Carl's"})
      merchant = Merchant.create!({name: "Pizza Crazy"})
      create_list(:merchant, 6)
      query_params = "?name=creatures"
      get "/api/v1/merchants/find#{query_params}"
      response_body = JSON.parse(response.body, symbolize_names: true)
      merchants = response_body[:data]
      # binding.pry
      expect(response).to_not be_successful
      expect(merchants[:name]).to eq(nil)
    end
end
