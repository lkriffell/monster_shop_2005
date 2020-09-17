class Item < ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than: 0

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def inventory_has_reached_limit?(cart)
    cart.contents[self.id.to_s] == self.inventory
  end

  def self.items_by_popularity(number, order = 'desc')
    select("items.name, sum(item_orders.quantity) AS total_quantity")
    .joins(:item_orders)
    .where(active?: true)
    .group(:name)
    .order("sum(item_orders.quantity) #{order}")
    .limit(number)
  end

  def loaded_image?
    begin
      open(self.image)
    rescue
      self.errors.add(:image)
      false
    end
  end
end
