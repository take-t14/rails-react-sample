Rails.application.routes.draw do
  get "product/list", to: "product#list"
  get "product/detail/:product_group_id", to: "product#detail"
  get "cart/show", to: "cart#show"
  get "order/form", to: "order#form"

  namespace :api, {format: 'json'} do
		resources :cart, only: [] do
			collection do
				post :add
			end
		end
		resources :order, only: [] do
			collection do
				post :check
				post :save
			end
		end
	end
end
