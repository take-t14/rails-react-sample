class CartItem < ApplicationRecord
  self.table_name = "cart_item"
  self.primary_keys = :product_id, :cart_id
	has_many :product, foreign_key: :product_id, primary_key: :product_id
  
  def self.make_cart_item_by_cart_id(cart_id)
    ret_cart_items = []
    cart_items = self.where("cart_id = ?", cart_id)
      .joins(product: [:color, :size])
			.select("*")
      .order("product.product_id")
      .order("product.product_name")
    cart_items.each do |cart_item|
      ret_cart_items.push(self.cart_item_db_to_array(cart_item))
    end
    return ret_cart_items
  end
 
  def self.cart_item_db_to_array(record)
    return {
        "cartId" => {"value" => record.cart_id},
        "quantity" => {"value" => record.quantity},
        "taxRate" => {"value" => record.tax_rate},
        "price" => {"value" => record.price},
        "priceTotal" => {"value" => record.price_total},
        "priceTaxIn" => {"value" => record.price_taxin},
        "priceTotalTaxin" => {"value" => record.price_total_taxin},
        "product" => Product.product_db_to_array(record)
    }
  end

end
