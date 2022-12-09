class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.find_name(name)
    # require "pry"; binding.pry
    where("name ILIKE ?", "%#{name}%").order(:name).first
  end
end
