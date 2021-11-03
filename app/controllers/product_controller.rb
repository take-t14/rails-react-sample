class ProductController < ApplicationController

  def list
    @view_model = {
      "productGroups" => ProductGroup.get_all()
    }
  end

  def detail
    @view_model = {
			"productGroup" => ProductGroup.get_product_group_by_id(params[:product_group_id]),
			"reviews" => Review.get_reviews_by_product_group_id(params[:product_group_id])
    }
  end

end
