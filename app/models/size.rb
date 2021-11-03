class Size < ApplicationRecord
  self.table_name = "size"
  has_many :product
end
