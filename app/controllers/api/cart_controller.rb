class Api::CartController < ApplicationController
	def add
		ret = nil
		if params["isRemove"] && 
			("true" == params["isRemove"] || "1" == params["isRemove"])
			Cart.remove_cart_item(params["productId"], session)
			ret = Cart.get_cart(session)
		elsif params["isAllRemove"] &&
			("true" == params["isAllRemove"] || "1" == params["isAllRemove"])
			Cart.remove_cart_item_all(session)
			ret = Cart.get_cart(session)
		else
			ret = Cart.add_cart(params["productId"].to_i, params["quantity"].to_i, session)
		end
		if ret.nil?
			throw "カートデータの取得に失敗しました"
		end
		render json: {"viewModel" => {"cart" => ret}}
	end
end