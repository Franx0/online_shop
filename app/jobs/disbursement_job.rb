class DisbursementJob < ApplicationJob
  queue_as :default

  def perform(order_id:)
    order = Order.find(order_id)
    order_amounts_per_week = Order.completed
                                  .where(merchant_id: order.merchant_id)
                                  .group_by_week(:completed_at, week_start: :monday)
                                  .sum(:disbursement)
    # Store in redis. Maybe better increase not re-calculate all orders.
    order.set_cache(key: "disbursements:merchants:#{order.merchant_id}",
                    values: order_amounts_per_week.to_json)
  end
end
