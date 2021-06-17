class Shopper < ApplicationRecord
  VALIDATABLE_ATTS = [:name, :email, :nif]
  has_many :orders

  validates *VALIDATABLE_ATTS, presence: true
end
