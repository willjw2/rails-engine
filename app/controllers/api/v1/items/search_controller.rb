class Api::V1::Items::SearchController < ApplicationController
  def index
    # require "pry"; binding.pry
    if (params[:max_price] || params[:min_price]) && params[:name]
      render json: {"errors": "Cannot send both a price parameter and a name"}, status: 400
    elsif (params[:max_price] && params[:max_price].to_f < 0)
      render json: {"errors": "max_price cannot be less than 0"}, status: 400
    elsif (params[:min_price] && params[:min_price].to_f < 0)
      render json: {"errors": "min_price cannot be less than 0"}, status: 400
    elsif params[:max_price] && params[:min_price]
      render json: ItemSerializer.format_items_merchant_id(Item.find_range(params[:min_price], params[:max_price]))
    elsif params[:name]
      render json: ItemSerializer.format_items_merchant_id(Item.find_name(params[:name]))
    elsif params[:min_price]
      render json: ItemSerializer.format_items_merchant_id(Item.find_min_price(params[:min_price]))
    elsif params[:max_price]
      render json: ItemSerializer.format_items_merchant_id(Item.find_max_price(params[:max_price]))
    end
  end
end
