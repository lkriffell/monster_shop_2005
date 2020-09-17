class ItemOrder < ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  enum status: %w(pending fulfilled unfulfilled)

  def subtotal
    price * quantity
  end

  def add_back_to_inventory
    item.update!(inventory: (item.inventory += quantity))
    self.update(status: 2)
  end

end
