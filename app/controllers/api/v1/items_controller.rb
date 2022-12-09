class Api::V1::ItemsController < ApplicationController
  def index
    # require "pry"; binding.pry
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      merchant_items = merchant.items
      render json: ItemSerializer.format_items(merchant_items)
    else
      render json: ItemSerializer.format_items(Item.all)
    end
  end
  def show
    render json: ItemSerializer.format_item(Item.find(params[:id]))
  end
  def create
    # require "pry"; binding.pry
    render json: ItemSerializer.format_item_merchant_id(Item.create(item_params))
  end
  def update
    render json: ItemSerializer.format_item_merchant_id(Item.update(params[:id], item_params))
  end
  def destroy
    render json: Item.delete(params[:id])
  end

private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
