class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name]
      render json: ItemSerializer.format_items(Item.find_name(params[:name]))
    elsif params[:min_price]
      render json: ItemSerializer.format_items(Item.find_min_price(params[:min_price]))
    elsif params[:max_price]
      render json: ItemSerializer.format_items(Item.find_max_price(params[:max_price]))
    elsif params[:max_price] && params[:min_price]

    end
  end
end
