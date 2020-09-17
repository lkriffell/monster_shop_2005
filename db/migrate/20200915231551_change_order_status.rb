class ChangeOrderStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :status, 'integer USING CAST(status AS integer)'
  end
end
