class ItemOrdersController < ApplicationController
  def update
    @item_order = ItemOrder.find(params[:id])
    @order = Order.find(@item_order.order_id)
    @item = Item.find(@item_order.item_id)
    @item.inventory -= @item_order.quantity
    @item.save!
    @item_order.status = 1
    @item_order.save!
    flash[:success] = "Order has been fulfilled."
    redirect_to "/orders/#{@order.id}"
  end
end
