module MergePendingOrder
  extend ActiveSupport::Concern

  included do
  end

  # 找到创建时间最早的 pending 订单, 当做原始订单
  def find_original_order
    Order.newly.where(device_id: device_id, application_id: application_id)
      .reorder("id ASC").first
  end

  # 找到除本身之外的其他 pending 订单
  def find_pending_orders
    Order.newly.where(device_id: device_id, application_id: application_id)
      .where.not(id: id)
  end

  # 汇总已经支付的订单金额, 合并订单时调用此方法
  def calculate_payment_total_with_pending_orders(orders)
    orders_payment_total = orders.inject(self.payment_total) { |sum, o| sum + o.payment_total }
    self.update_column(:payment_total, orders_payment_total)
    update_payment_state
  end

  # 汇总已经订单产品金额, 创建，合并订单时调用此方法
  def calculate_item_total
    item_total = line_items.inject(0){ |sum, item| sum + item.sale_price * item.quantity }
    update({item_total: item_total})
    # 重新计算运费, 包邮逻辑放在其他 concerns 中
    calculate_shipping_charge
  end

  # 合并 line items
  def merge_line_items(orders)
    orders.each do |order|
      order.line_items.each { |item| self.line_items << item }
      order.coupons.each { |coupon| self.coupons << coupon }
    end
  end

  # TODO: need add some test to make logic is right, then make this method private.
  def merge_pending_orders
    original_order = find_original_order
    pending_orders = original_order.find_pending_orders

    return if pending_orders && pending_orders.size.zero?
    original_order.merge_line_items(pending_orders)
    original_order.calculate_payment_total_with_pending_orders(pending_orders)
    original_order.calculate_item_total

    coupon_ids = original_order.coupons.collect(&:to_param)
    original_order.calculate_total_by_coupons(coupon_ids)

    pending_orders.destroy_all
  end

  module ClassMethods
  end
end
