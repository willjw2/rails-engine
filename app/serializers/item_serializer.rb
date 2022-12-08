class ItemSerializer
  def self.format_items(items)
    {
      data: items.map do |item|
        {
          id: item.id,
          type: "item",
          attributes: {
            name: item.name,
            description: item.description,
            unit_price: item.unit_price
          }
        }
      end
    }
  end
  def self.format_item(item)
    {
      data: {
        id: item.id,
        type: "item",
        attributes: {
          name: item.name,
          description: item.description,
          unit_price: item.unit_price
        }
      }
    }
  end
end
