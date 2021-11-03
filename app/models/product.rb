class Product < ApplicationRecord
  self.table_name = "product"
  belongs_to :product_group
  belongs_to :cart_item, foreign_key: :product_id, primary_key: :product_id
  belongs_to :color
  belongs_to :size

  def self.calc_price_taxin(price, tax_rate)
		return price + (price * tax_rate / 100).floor
	end

  def self.product_db_to_array(record)
    price = record.price;
    price_taxin = self.calc_price_taxin(record.price, record.tax_rate)
    return {
      "productId" => {"value" => record.product_id},
      "productGroupId" => {"value" => record.product_group_id},
      "productName" => {"value" => record.product_name},
      "price" => {"value" => price},
      "priceTaxIn" => {"value" => price_taxin},
      "taxRate" => {"value" => record.tax_rate},
      "color" => {
        "colorId" => {"value" => record.color_id},
        "colorName" => {"value" => record.color_name}
      },
      "size" => {
        "sizeId"  => {"value" => record.size_id},
        "sizeName" => {"value" => record.size_name}
      }
    }
  end
end
