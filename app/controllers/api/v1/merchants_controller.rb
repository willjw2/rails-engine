class Api::V1::MerchantsController < ApplicationController
  def index
    # render json: Merchant.all
    render json: MerchantSerializer.format_merchants(Merchant.all)
  end
  def show
    # require "pry"; binding.pry
    if params[:item_id]
      item =  Item.find(params[:item_id])
      render json: MerchantSerializer.format_merchant(Merchant.find(item.merchant_id))
    else
      render json: MerchantSerializer.format_merchant(Merchant.find(params[:id]))
    end
  end
end

# def show
#         # require 'pry';binding.pry
#         if Market.exists?(params[:id])
#             render json: MarketSerializer.new(Market.find(params[:id]))
#         else
#             render json: {"errors": "Market with this id doesn't exist"} , status: 404
#         end
#     end
