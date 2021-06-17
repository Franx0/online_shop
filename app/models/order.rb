class Order < ApplicationRecord
  include Cacheable

  belongs_to :merchant, optional: true
  belongs_to :shopper, optional: true

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  # Should be better to create a custom event to listening for order changes
  before_create :set_disbursement, :set_fee
  after_update :calculate_disbursement

  scope :completed, -> { where.not(completed_at: nil) }

  def complete!
    update!(completed_at: DateTime.now)
  end

  def calculate_fee
    return amount.percent_of(1) if amount < 50
    return amount.percent_of(0.95) if (51..300).include?(amount)
    return amount.percent_of(0.85) if amount > 300
  end

  private

  def set_disbursement
    self.disbursement = (amount - calculate_fee)
  end

  def set_fee
    self.fee = calculate_fee
  end

  def calculate_disbursement
    DisbursementJob.perform_later(order_id: id) if (will_save_change_to_completed_at? || saved_change_to_completed_at?)
  end
end
