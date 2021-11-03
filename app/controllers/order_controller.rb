class OrderController < ApplicationController

  def form
    @view_model = {
      "cart" => Cart.get_cart(session)
    }
  end

end
