require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships and validations' do
    it { should have_many :items }

    it { should validate_presence_of :name }

    describe 'methods' do
      it 'can find a merchant by name in search' do
        merchant1 = Merchant.create!({name: "Crazy Carl's"})
        merchant2 = Merchant.create!({name: "Pizza Crazy"})
        create_list(:merchant, 6)
        expect(Merchant.search_by_name("CrAzY")).to eq(merchant1)
        expect(Merchant.search_by_name("CrAzY")).to_not eq(merchant2)
      end
    end
  end
end
