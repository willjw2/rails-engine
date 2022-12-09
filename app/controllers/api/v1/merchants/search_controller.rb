class Api::V1::Merchants::SearchController < ApplicationController
  def show
    # require "pry"; binding.pry
    if params[:name] == ""
      render json: {"errors": "name parameter cannot be empty"}, status: 400
    elsif params[:name]
      render json: MerchantSerializer.format_merchant(Merchant.find_name(params[:name]))
    else
      render json: {"errors": "parameter cannot be missing"}, status: 400
    end
  end
end
