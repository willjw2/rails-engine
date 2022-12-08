class Api::V1::MerchantsController < ApplicationController
  def index
    # render json: Merchant.all
    render json: MerchantSerializer.format_merchants(Merchant.all)
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
