require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end
  describe 'class methods' do
    it '#find_name' do
      item1 = create(:item, name: "Apple")
      item2 = create(:item, name: "Banana")
      item3 = create(:item, name: "apple pie")
      item4 = create(:item, name: "Cranberry apple juice")
      item5 = create(:item, name: "Car")

      expect(Item.find_name('Apple')).to eq([item1, item3, item4])
    end
    it '#find_min_price' do
      item1 = create(:item, unit_price: 1.50)
      item2 = create(:item, unit_price: 2.00)
      item3 = create(:item, unit_price: 3.50)
      item4 = create(:item, unit_price: 4.00)
      item5 = create(:item, unit_price: 5.01)

      expect(Item.find_min_price(3.5)).to eq([item3, item4, item5])
    end
    it '#find_max_price' do
      item1 = create(:item, unit_price: 1.50)
      item2 = create(:item, unit_price: 2.00)
      item3 = create(:item, unit_price: 3.50)
      item4 = create(:item, unit_price: 4.00)
      item5 = create(:item, unit_price: 5.01)

      expect(Item.find_max_price(3.0)).to eq([item1, item2])
    end
    it '#find_range' do
      item1 = create(:item, unit_price: 1.50)
      item2 = create(:item, unit_price: 2.00)
      item3 = create(:item, unit_price: 3.50)
      item4 = create(:item, unit_price: 4.00)
      item5 = create(:item, unit_price: 5.01)

      expect(Item.find_range(2.0, 4.0)).to eq([item2, item3, item4])
    end
  end
end
