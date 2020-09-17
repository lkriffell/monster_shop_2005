class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @items = @merchant.items
    @top_five_items = Item.items_by_popularity(5)
    @bottom_five_items = Item.items_by_popularity(5, 'asc')
    render "items/index"
  end

  def update
    @item = Item.find(item_params[:item_id])
    @item.update(active?: !@item.active?)
    if @item.active?
      flash[:success] = "#{@item.name} is now active."
    else
      flash[:success] = "#{@item.name} is now inactive."
    end
    redirect_to "/merchant/items/#{current_user.merchant_id}"
  end

  def destroy
    item = Item.find(item_params[:item_id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to "/merchant/items/#{current_user.merchant_id}"
  end

  private
  def item_params
    params.permit(:item_id)
  end
end
