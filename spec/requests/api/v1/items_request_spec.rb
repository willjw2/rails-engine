require 'rails_helper'

describe "Items API" do
  it "sends all records of items" do
    create_list(:item, 3)
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)
    # require "pry"; binding.pry

    items[:data].each do |item|
      expect(item).to have_key(:id)
      # require "pry"; binding.pry
      expect(item[:id]).to be_a(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end
  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)
  end
  it "can create a new item" do
    id = create(:merchant).id
    item_params = ({
                    name: "Test Item",
                    description: "test description here",
                    unit_price: 100.99,
                    merchant_id: id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    expect(response).to be_successful

    created_item = Item.last
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])

    item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)
  end
  it "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = {
                    "name": "value1",
                    "description": "value2",
                    "unit_price": 100.99,
                  }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)
    # require "pry"; binding.pry
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("value1")
    expect(item.description).to eq("value2")
    expect(item.unit_price).to eq(100.99)
  end
  it "can destroy an existing item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    expect {delete "/api/v1/items/#{item.id}"}.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
  it "can return the merchant associated with an item" do
    item = create(:item)
    merchant = Merchant.find_by(id: item.merchant_id)

    get "/api/v1/items/#{item.id}/merchant"
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:type]).to eq("merchant")
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end
  context "can find all items that match a search term" do
    it "can find all items that match a name search term" do
      item1 = create(:item, name: "Apple")
      item2 = create(:item, name: "Banana")
      item3 = create(:item, name: "apple pie")
      item4 = create(:item, name: "Cranberry apple juice")
      item5 = create(:item, name: "Car")

      get "/api/v1/items/find_all?name=apple"
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response).to be_successful
      # require "pry"; binding.pry
      expect(items.count).to eq(3)
    end
    it "can find all items that are above or equal to a minimum price search term" do
      create(:item, unit_price: 1.50)
      create(:item, unit_price: 2.00)
      create(:item, unit_price: 3.50)
      create(:item, unit_price: 4.00)
      create(:item, unit_price: 5.01)

      get "/api/v1/items/find_all?min_price=3.5"
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      # require "pry"; binding.pry
      expect(response).to be_successful
      expect(items.count).to eq(3)
    end
    it "can find all items that are less than or equal to a maximum price search term" do
      create(:item, unit_price: 1.50)
      create(:item, unit_price: 2.00)
      create(:item, unit_price: 3.50)
      create(:item, unit_price: 4.00)
      create(:item, unit_price: 5.01)

      get "/api/v1/items/find_all?max_price=3.0"
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      # require "pry"; binding.pry
      expect(response).to be_successful
      expect(items.count).to eq(2)
    end
    it "can find all items that are between a min and max price search term" do
      create(:item, unit_price: 1.50)
      create(:item, unit_price: 2.00)
      create(:item, unit_price: 3.50)
      create(:item, unit_price: 4.00)
      create(:item, unit_price: 5.01)

      get "/api/v1/items/find_all?max_price=4.0&min_price=2.00"
      items = JSON.parse(response.body, symbolize_names: true)[:data]
      # require "pry"; binding.pry
      expect(response).to be_successful
      expect(items.count).to eq(3)
    end
    it "will return an error if both a price and a name search term is sent" do
      create(:item, unit_price: 1.50)
      create(:item, unit_price: 2.00)
      create(:item, unit_price: 3.50)
      create(:item, unit_price: 4.00)
      create(:item, unit_price: 5.01)
      get "/api/v1/items/find_all?max_price=4.0&min_price=2.00&name=test"
      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      # require "pry"; binding.pry
      expect(json[:errors]).to eq("Cannot send both a price parameter and a name")
    end
    it "will return an error if max_price is less than 0" do
      create(:item, unit_price: 1.50)
      create(:item, unit_price: 2.00)
      create(:item, unit_price: 3.50)
      create(:item, unit_price: 4.00)
      create(:item, unit_price: 5.01)
      get "/api/v1/items/find_all?max_price=-4.0"
      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      # require "pry"; binding.pry
      expect(json[:errors]).to eq("max_price cannot be less than 0")
    end
    it "will return an error if min_price is less than 0" do
      create(:item, unit_price: 1.50)
      create(:item, unit_price: 2.00)
      create(:item, unit_price: 3.50)
      create(:item, unit_price: 4.00)
      create(:item, unit_price: 5.01)
      get "/api/v1/items/find_all?min_price=-4.0"
      expect(response.status).to eq(400)
      json = JSON.parse(response.body, symbolize_names: true)
      # require "pry"; binding.pry
      expect(json[:errors]).to eq("min_price cannot be less than 0")
    end
  end
end
