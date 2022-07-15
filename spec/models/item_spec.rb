require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships and validations' do
    it { should belong_to :merchant }

    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'class methods' do
    it 'can find all items by fragment of name in search' do
      merchant1 = Merchant.create!({name: "Crazy Carl's"})
      merchant2 = Merchant.create!({name: "Pizza Crazy"})
      item1 = Item.create!({name: "Winchester", description: "Sweet rifle", unit_price: 300.99, merchant_id: 1})
      item2 = Item.create!({name: "Chess", description: "Strategy game", unit_price: 41.99, merchant_id: 1})
      create_list(:item, 12)
      expect(Item.search_by_fragment("")).to eq(merchant1)
      expect(Item.search_by_fragment("")).to_not eq(merchant2)
    end
  end
end
