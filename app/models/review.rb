class Review < ApplicationRecord
  self.table_name = "review"
	has_many :review_product

  def self.get_reviews_by_product_group_id(product_group_id)
    obj_review = self.joins(review_product: [:product])
    obj_review = obj_review.where("product.product_group_id = ?", product_group_id)
    return self.review_db_to_array(obj_review);
  end

  def self.review_db_to_array(records)
    reviews = []
    records.each do |record|
      review = {}
      review["reviewId"] = {"value" => record.review_id}
      review["initial"] = {"value" => record.initial}
      review["reviewPoint"] = {"value" => record.review_point}
      review["comment"] = {"value" => record.comment}
      review["insDate"] = {"value" => record.ins_date}
      reviews.push(review)
    end
    return reviews;
  end

end
