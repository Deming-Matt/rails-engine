class Api::V1::MerchantItemsController < ApplicationController

  def index
    # binding.pry
    merchant = Merchant.find(params[:merchant_id])
    if merchant.nil?
      render status: 404
    else
      render json: ItemSerializer.new(merchant.items)
    end
  end
end
