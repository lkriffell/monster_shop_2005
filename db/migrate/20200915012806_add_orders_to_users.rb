class AddOrdersToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :order, foreign_key: true
  end
end
