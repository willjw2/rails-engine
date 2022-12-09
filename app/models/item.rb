class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_name(name)
    where("name ILIKE ?", "%#{name}%")
  end
  def self.find_min_price(min_price)
    # require "pry"; binding.pry
    where("unit_price >= ?", min_price).order(:unit_price)
    # where("unit_price >= #{min_price}").order(:unit_price)
  end
  def self.find_max_price(max_price)
    where("unit_price <= ?", max_price).order(:unit_price)
  end
end
