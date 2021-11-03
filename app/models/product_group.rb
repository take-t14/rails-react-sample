class ProductGroup < ApplicationRecord
  self.table_name = "product_group"
	has_many :product

	def self.get_all()
		records = self.get_product_group_query()
		return self.product_group_db_to_array(records, true)
	end

  def self.get_product_group_query(product_group_id = nil)
		obj_product_group = self.joins(product: [:color, :size])
			.select("*")
			.order("product.product_group_id")
			.order("product.color_id")
			.order("product.size_id")
			.order("product.product_id")
		if false == product_group_id.nil?
			obj_product_group = obj_product_group.where("product.product_group_id = ?", product_group_id)
    end
		return obj_product_group
  end

	def self.search_color_sizse_array(search_values, str_id_name, search_id)
		is_exist = false
		search_values.each do |search_value|
			if search_value[str_id_name]["value"] == search_id
				is_exist = true
				break
			end
		end
		return is_exist
	end

  def self.product_group_db_to_array(records, skip_products)
		product_group = {}
		product_groups = []
		records.each do |record|
			if 0 >= product_group.count || product_group["productGroupId"]["value"] != record.product_group_id
				if 0 < product_group.count
					product_groups.push(product_group)
				end
				product_group = {}
				product_group["productGroupId"] = {"value" => record.product_group_id}
				product_group["productGroupId"] = {"value" => record.product_group_id}
				product_group["productGroupName"] = {"value" => record.product_group_name}
				product_group["lowPrice"] = {"value" => record.price}
				product_group["heightPrice"] = {"value" => record.price}
				product_group["lowPriceTaxIn"] = {"value" => Product.calc_price_taxin(record.price, record.tax_rate)}
				product_group["heightPriceTaxIn"] = {"value" => Product.calc_price_taxin(record.price, record.tax_rate)}
				product_group["products"] = {}
				product_group["colors"] = []
				product_group["sizes"] = []
			end
			price = record.price
			price_taxin = Product.calc_price_taxin(record.price, record.tax_rate);
			if !skip_products
				if !product_group["products"].key?(record.color_name)
					product_group["products"][record.color_name] = {}
				end
				product_group["products"][record.color_name][record.size_name] = Product.product_db_to_array(record)
			end
			if price < product_group["lowPrice"]["value"]
				product_group["lowPrice"]["value"] = price
			end
			if price > product_group["heightPrice"]["value"]
				product_group["heightPrice"]["value"] = price
			end
			if price_taxin < product_group["lowPriceTaxIn"]["value"]
				product_group["lowPriceTaxIn"]["value"] = price
			end
			if price_taxin > product_group["heightPriceTaxIn"]["value"]
				product_group["heightPriceTaxIn"]["value"] = price
			end
			if !self.search_color_sizse_array(product_group["colors"], "colorId", record.color_id)
				product_group["colors"].push({
					"colorId" => {"value" => record.color_id},
					"colorName" => {"value" => record.color_name}
				})
			end
			if !self.search_color_sizse_array(product_group["sizes"], "sizeId", record.size_id)
				product_group["sizes"].push({
					"sizeId" => {"value" => record.size_id},
					"sizeName" => {"value" => record.size_name}
				})
			end
		end
		if 0 < product_group.count
			product_groups.push(product_group)
		end
		return product_groups
	end

  def self.get_product_group_by_id(product_group_id = nil)
    records = self.get_product_group_query(product_group_id)
		product_groups = self.product_group_db_to_array(records, false)
		if 0 < product_groups.count
			return product_groups[0]
		end
		return []
  end
  
end
