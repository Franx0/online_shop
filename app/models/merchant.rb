class Merchant < ApplicationRecord
  VALIDATABLE_ATTS = [:name, :email, :cif]

  has_many :orders

  validates *VALIDATABLE_ATTS, presence: true
end
