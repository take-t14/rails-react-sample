class CartController < ApplicationController

  def show
    @view_model = {
      "cart" => Cart.get_cart(session)
    }
  end

end
