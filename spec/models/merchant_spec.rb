require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
  end
  describe 'class methods' do
    it '#find_name' do
      merchant1 = create(:merchant, name: "Will")
      merchant2 = create(:merchant, name: "Akhil")
      merchant3 = create(:merchant, name: "Dustin")
      merchant4 = create(:merchant, name: "Z WILL")

      expect(Merchant.find_name("Will")).to eq(merchant1)
    end
  end
end
