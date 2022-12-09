class Api::V1::Merchants::SearchController < ApplicationController
  def show
    require "pry"; binding.pry
    render json: MerchantSerializer.format_merchant(Merchant.find_name(params[:name]))
  end
end
