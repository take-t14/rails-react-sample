class Api::OrderController < ApplicationController
	def check
		cart = Cart.get_cart(session)
		if cart["cartId"].nil? || 0 >= cart["items"].count
			throw "カートが空です"
		end
		order = OrderTable.new(
			last_name: params["last_name"],
			first_name: params["first_name"],
			mail: params["mail"],
			tel: params["tel"],
			zip: params["zip"],
			address1: params["address1"]
		)
		status = 200
		ret = { "cart" => cart }
		if !order.valid?
			status = 400
			ret = { "errors" => order.errors }
		end
		render json: ret, status: status
	end
	def save
		cart = Cart.get_cart(session)
		if cart["cartId"].nil? || 0 >= cart["items"].count
			throw "カートが空です"
		end
		order_table = OrderTable.save_order(cart, params, session)
		order = OrderTable.order_db_to_view_model(order_table)
		OrderMailer.order_mail(order, request).deliver
		render json: { "cart" => cart }
	end
end