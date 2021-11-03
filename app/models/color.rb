class Color < ApplicationRecord
  self.table_name = "color"
  has_many :product
end
