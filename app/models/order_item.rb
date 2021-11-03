class OrderItem < ApplicationRecord
  self.table_name = "order_item"

  def self.get_order_item_by_id(order_table_id)
    return self.where("order_table_id = ?", order_table_id)
  end

end
