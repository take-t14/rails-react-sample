class OrderTable < ApplicationRecord
  self.table_name = "order_table"
  validates :last_name, presence: { message: "氏名を入力してください。" }
  validates :last_name, length: { maximum: 20, message: "氏名は20字以内でお願いします。" }
  validates :first_name, presence: { message: "名前を入力してください。" }
  validates :first_name, length: { maximum: 20, message: "名前は20字以内でお願いします。" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :mail, presence: { message: "メールアドレスを入力してください。" }
  validates :mail, format: { with: VALID_EMAIL_REGEX, message: "メールアドレスの入力に誤りがあります。" }
  VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}[-(]?\d{4}|\d{2}[-(]?\d{3}|\d{3}[-(]?\d{2}|\d{4}[-(]?\d{1})[-)]?\d{4}\z|\A0[5789]0[-]?\d{4}[-]?\d{4}\z/
  validates :tel, presence: { message: "電話番号を入力してください。" } 
  validates :tel, format: { with: VALID_PHONE_NUMBER_REGEX, message: "電話番号の入力に誤りがあります。" }
  validates :zip, presence: { message: "郵便番号を入力してください。" } 
  validates :zip, format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: "郵便番号の記入に誤りがあります。" }
  validates :address1, presence: { message: "住所を入力してください。" } 

  def self.save_order(cart, params, session)
    OrderTable.transaction do
      OrderItem.transaction do
        order_table = OrderTable.new(
          total: cart["total"]["value"],
          total_taxin: cart["totalTaxin"]["value"],
          last_name: params["last_name"],
          first_name: params["first_name"],
          mail: params["mail"],
          tel: params["tel"],
          zip: params["zip"],
          address1: params["address1"],
        )
        order_table.save
        cart["items"].each do |cart_item|
          order_item = OrderItem.find_or_initialize_by(order_table_id: order_table.order_table_id,
            product_id: cart_item["product"]["productId"]["value"])
          order_item.update_attributes(
            quantity: cart_item["quantity"]["value"],
            tax_rate: cart_item["taxRate"]["value"],
            price: cart_item["price"]["value"],
            price_total: cart_item["priceTotal"]["value"],
            price_taxin: cart_item["priceTaxIn"]["value"],
            price_total_taxin: cart_item["priceTotalTaxin"]["value"]
          )
        end
        session[:mvcCartId] = nil
        return order_table
      end
    end
  end
  def self.order_db_to_view_model(order_table_record)
    order = {
      "lastName" => {"value" => order_table_record.last_name},
      "firstName" => {"value" => order_table_record.first_name},
      "orderTableId" => {"value" => order_table_record.order_table_id},
      "insDate" => {"value" => order_table_record.ins_date},
      "mail" => {"value" => order_table_record.mail},
      "totalTaxin" => {"value" => order_table_record.total_taxin},
      "items" => []
    }
    order_items = OrderItem.get_order_item_by_id(order_table_record.order_table_id)
    order_items.each do |order_item|
      product = Product.find(order_item.product_id)
      order["items"].push({
        "quantity" => {"value" => order_item.quantity},
        "priceTotalTaxin" => {"value" => order_item.price_total_taxin},
        "product" => {"productName" => {"value" => product.product_name}}
      })
    end
    return order
  end
end
