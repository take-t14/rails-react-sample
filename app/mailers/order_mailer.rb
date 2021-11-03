class OrderMailer < ApplicationMailer
	def order_mail(order, request)
		@order = order
		@request = request
		mail(to: @order["mail"]["value"], subject: '【XXXXショップ】ご注文ありがとうございます')
	end
end
