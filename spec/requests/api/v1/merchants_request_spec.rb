require 'rails_helper'

describe "Merchants API" do
  it "sends all records of merchants" do
    create_list(:merchant, 3)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:type]).to eq("merchant")
    end
  end
  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"
    # require "pry"; binding.pry
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:type]).to eq("merchant")
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end
  it "can return the items associated with a merchant" do
    id = create(:merchant)
    other_item = create(:item).id

    3.times { create(:item, merchant: id) }

    get "/api/v1/merchants/#{id.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:id]).to_not eq(other_item)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end
  context "can find one merchant that match a search term" do
    it "can find one merchant by a name parameter" do
      merchant1 = create(:merchant, name: "Will")
      merchant2 = create(:merchant, name: "Akhil")
      merchant3 = create(:merchant, name: "Dustin")
      merchant4 = create(:merchant, name: "Rat")

      get "/api/v1/merchants/find?name=Will"

      expect(response).to be_successful
    end
  end
end
