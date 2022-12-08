require 'rails_helper'

describe "Merchants API" do
  it "sends all records of merchants" do
    create_list(:merchant, 3)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:id]).to be_an(Integer)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:type]).to eq("merchant")
    end

    # require "pry"; binding.pry
  end
  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"
    # require "pry"; binding.pry
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data][:id]).to be_an(Integer)
    expect(merchant[:data][:type]).to eq("merchant")
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

end
