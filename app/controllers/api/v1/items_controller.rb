class Api::V1::ItemsController < ApplicationController

  def index
    if merchant.nil?
      return {status: "404"}
    else
      render json: ItemSerializer.new(merchant.items)
    end
  end
end
