class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.format_items(Item.all)
  end
  def show
    render json: ItemSerializer.format_item(Item.find(params[:id]))
  end
  def create
    # require "pry"; binding.pry
    render json: ItemSerializer.format_create(Item.create(item_params))
  end
  def update
    render json: ItemSerializer.format_update(Item.update(params[:id], item_params))
  end

private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
