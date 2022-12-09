class Api::V1::ItemsController < ApplicationController
  def index
    # require "pry"; binding.pry
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      merchant_items = merchant.items
      render json: ItemSerializer.format_items_merchant_id(merchant_items)
    else
      render json: ItemSerializer.format_items_merchant_id(Item.all)
    end
  end
  def show
    render json: ItemSerializer.format_item_merchant_id(Item.find(params[:id]))
  end
  def create
    # require "pry"; binding.pry
    render json: ItemSerializer.format_item_merchant_id(Item.create!(item_params)), status: 201
  end
  def update
    # require "pry"; binding.pry
    if Item.exists?(params[:id]) && (Merchant.exists?(params[:item][:merchant_id]) || params[:item][:merchant_id] == nil)
      render json: ItemSerializer.format_item_merchant_id(Item.update(params[:id], item_params))
    else
      render json: {"errors": "Invalid item or merchant id"}, status: 404
    end
  end
  def destroy
    render json: Item.delete(params[:id])
  end

private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
