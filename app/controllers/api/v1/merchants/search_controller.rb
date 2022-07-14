class Api::V1::Merchants::SearchController < ApplicationController

  def index

  end

  def show
    merchant = Merchant.search_by_name(params[:name])
    if merchant.present?
      render json: MerchantSerializer.new(merchant)
    else
      render json: {data: Merchant.new}, status: 404
    end
  end


  private

    def search_params
      params.permit(:name)
    end
end
