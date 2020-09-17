class Merchant::ItemOrdersController < ApplicationController
  def update
    @item_order = ItemOrder.find(params[:id])
    @order = Order.find(@item_order.order_id)
    @item = Item.find(@item_order.item_id)
    @item.update(inventory: (@item.inventory -= @item_order.quantity))
    @item_order.update(status: 1)
    flash[:success] = "Order has been fulfilled."
    redirect_to "/merchant/orders/#{@order.id}"
  end
end
