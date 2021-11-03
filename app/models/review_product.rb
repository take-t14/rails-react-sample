class ReviewProduct < ActiveRecord::Base
  self.table_name = "review_product"
	self.primary_keys = :review_id, :product_id
	has_many :review
	has_many :product, foreign_key: :product_id, primary_key: :product_id
end
