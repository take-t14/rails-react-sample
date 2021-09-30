class ProductController < ApplicationController

  def list
    @products = Product.all
  end

end
