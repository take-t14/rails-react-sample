class Cart < ApplicationRecord
  self.table_name = "cart"

  def self.remove_cart_item(product_id, session)
    CartItem.transaction do
      if !session[:mvcCartId]
        break
      end
      cart_id = session[:mvcCartId]
      CartItem.where("cart_id = ?", cart_id)
        .where("product_id = ?", product_id)
        .delete_all
      self.update_cart_price(cart_id)
    end
  end

  def self.update_cart_price(cart_id)
    cart_items = CartItem.where("cart_id = ? ", cart_id)
    total = 0
    total_tax_in = 0
    cart_items.each do |cart_item|
      total += cart_item.price_total
      total_tax_in += cart_item.price_total_taxin
    end
    cart = Cart.find_or_initialize_by(cart_id: cart_id)
    cart.update_attributes(
      total: total,
      total_taxin: total_tax_in
    )
  end

  def self.get_cart(session)
    cart_id = nil
    cart_items_rec = nil
    if session[:mvcCartId]
      cart_id = session[:mvcCartId]
      cart_items_rec = Cart.find(cart_id)
    end
    return self::cart_db_to_array(cart_items_rec);
  end

  def self.cart_db_to_array(record = nil)
    cart = {
      "cartId" => {"value" => nil},
      "updDate" => {"value" => ""},
      "total" => {"value" => 0},
      "totalTaxin" => {"value" => 0},
      "items" => {}
    }
    if record.nil?
      return cart
    end
    cart["cartId"] = {"value" => record.cart_id}
    cart["updDate"] = {"value" => record.upd_date}
    cart["total"] = {"value" => record.total}
    cart["totalTaxin"] = {"value" => record.total_taxin}
    cart["items"] = CartItem.make_cart_item_by_cart_id(record.cart_id)
    return cart
  end

  def self.remove_cart_item_all(session)
    CartItem.transaction do
      if !session[:mvcCartId]
        break
      end
      cart_id = session[:mvcCartId]
      CartItem.where("cart_id = ?", cart_id).delete_all
      self.update_cart_price(cart_id)
    end
  end

  def self.add_cart(product_id, quantity, session)
    Product.transaction do
      CartItem.transaction do
        Cart.transaction do
          cart_id = nil
          cart = nil
          product = Product.find(product_id)
          price_taxin = Product.calc_price_taxin(product.price, product.tax_rate)
          if session[:mvcCartId]
            cart_id = session[:mvcCartId]
            cart = self.find(cart_id)
            cart_item = CartItem
              .where("cart_id = ?", cart_id)
              .where("product_id = ?", product_id)
              .first()
            if !cart.nil? && !cart_item.nil?
              quantity += cart_item.quantity
            end
          else
            cart = Cart.new(
              "total" => product.price * quantity,
              "total_taxin" => price_taxin * quantity,
              "upd_date" => Time.now
            )
            cart.save
          end
          if cart.nil?
            throw ActiveRecord::RecordNotFound()
          end
          cart = CartItem.find_or_initialize_by(cart_id: cart.cart_id, product_id: product_id)
          cart.update_attributes(
            quantity: quantity,
            price_total: product.price * quantity,
            price_taxin: price_taxin,
            price_total_taxin: price_taxin * quantity
          )
          self.update_cart_price(cart.cart_id)
          ret_cart = self.cart_db_to_array(self.find(cart.cart_id))
          session[:mvcCartId] = cart.cart_id
          return ret_cart
        end
      end
    end
  end

end
