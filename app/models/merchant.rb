class Merchant < ApplicationRecord
  include Cacheable

  STORE_CACHE_KEY='disbursements:merchants'
  VALIDATABLE_ATTS = [:name, :email, :cif]

  has_many :orders

  validates *VALIDATABLE_ATTS, presence: true

  def disbursements(date: nil)
    disbursements = {}
    cache_key = STORE_CACHE_KEY
    cache_key = (id.nil? ? [cache_key, '*'] : [cache_key, id]).join(':')

    self.get_keys(key: cache_key).last.each do |k|
      key_id = (id || k.split(':').third)
      value = self.get_cache(key: k)
      parsed_value = value.present? ? JSON.parse(value) : {}
      disbursements[key_id] = (date.present? ? parsed_value.slice(date.strftime('%Y-%m-%d')) : parsed_value)
    end

    disbursements
  end
end
