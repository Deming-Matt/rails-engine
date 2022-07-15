class Api::V1::Items::SearchController < ApplicationController

  def index
    items = Item.search_by_fragment(params[:name])
    if items.present?
      render json: ItemSerializer.new(items)
    else
      render json: { data: [] }, status: 404
    end
  end
end
