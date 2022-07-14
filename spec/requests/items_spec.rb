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

  describe "GET /show" do
    it 'sends a single item' do
      item = create(:item)
      id = item.id
      get "/api/v1/items/#{id}"

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(response).to be_successful
      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be_an(Integer)

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)

      expect(item[:attributes]).to_not have_key(:created_at)
    end
  end

  describe "POST /create" do
    it 'creates a single item' do
      merchant = create(:merchant)
      id = merchant.id
      item_params = {
        name: "Foghorn",
        description: "Loud Noises",
        unit_price: 32.99,
        merchant_id: id
      }

      post "/api/v1/items", params: { item: item_params }, as: :json
      expect(response).to be_successful
      created_item = Item.last
      expect(created_item).to be_a(Item)
      expect(created_item.name).to be_a(String)
      expect(created_item.name).to eq("Foghorn")
      expect(created_item.description).to be_a(String)
      expect(created_item.description).to eq("Loud Noises")
      expect(created_item.unit_price).to be_a(Float)
      expect(created_item.unit_price).to eq(32.99)
      expect(created_item.merchant_id).to be_a(Integer)
      expect(created_item.merchant_id).to eq(id)
    end
  end

  describe "DELETE /destroy" do
    it 'deletes the last item' do
      merchant = create(:merchant)
      id = merchant.id
      item_params = {
        name: "Foghorn",
        description: "Loud Noises",
        unit_price: 32.99,
        merchant_id: id
      }

      item = create(:item)
      item_id = item.id
      post "/api/v1/items", params: { item: item_params }, as: :json
      delete "/api/v1/items/#{item_id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
    end
    # it { should respond_with 204 }
  end

  describe "PUT /patch" do
    it 'can update an item' do
      merchant = create(:merchant)
      id = merchant.id
      item = create(:item)
      item_id = item.id
      item_params = {
        name: "Foghorn",
        description: "Loud Noises",
        unit_price: 32.99,
        merchant_id: id
      }
      put "/api/v1/items/#{item_id}", params: { item: item_params }, as: :json

      response_body = JSON.parse(response.body, symbolize_names: true)
      updated_item = response_body[:data]

      expect(response).to be_successful
      expect(updated_item).to have_key(:id)
      expect(updated_item).to have_key(:attributes)
      expect(updated_item[:attributes]).to have_key(:name)
      expect(updated_item[:attributes]).to have_key(:description)
      expect(updated_item[:attributes]).to have_key(:unit_price)
      expect(updated_item[:attributes]).to have_key(:merchant_id)
    end
  end

  describe "GET find a merchant of item" do
    it 'can find a merchant of a new item - happy and sad' do
      merchant = create(:merchant)
      merchant_id = merchant.id
      item = create_list(:item, 1, merchant_id: merchant_id)
      create_list(:merchant, 2)

      get "/api/v1/items/#{item.first.id}/merchant"
      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant[:attributes][:name]).to be_a(String)

      expect(merchant[:attributes][:name]).to_not eq(Merchant.second.name)
      expect(merchant[:attributes][:name]).to_not eq(Merchant.last.name)
    end
  end 
end
