module MergePendingOrder
  extend ActiveSupport::Concern

  included do
  end

  # 找到创建时间最早的 pending 订单且支付方式相同的, 当做原始订单
  def find_original_order
    Order.newly
      .where(
        device_id: device_id,
        application_id: application_id,
        pay_type: pay_type
      ).reorder("id ASC").first
  end

  # 找到除本身之外且支付方式相同的其他 pending 订单
  def find_pending_orders
    Order.newly
      .where(
        device_id: device_id,
        application_id: application_id,
        pay_type: pay_type
      ).where.not(id: id)
  end

  # 汇总已经支付的订单金额, 合并订单时调用此方法
  def calculate_payment_total_with_pending_orders(orders)
    orders_payment_total =
      orders.inject(self.payment_total) { |sum, o| sum + o.payment_total }
    self.update_column(:payment_total, orders_payment_total)
  end

  # 汇总已经订单产品金额, 创建，合并订单时调用此方法
  def calculate_item_total
    item_total =
      line_items.inject(0){ |sum, item| sum + item.sale_price * item.quantity }
    update({item_total: item_total})
    # 更新支付状态
    update_payment_state
    # 重新计算运费, 包邮逻辑放在其他 concerns 中
    calculate_shipping_charge
  end

  # 合并 line items
  def merge_line_items(orders)
    orders.each do |order|
      order.line_items.each { |item| self.line_items << item }
      # FIX ME:
      # 折扣优惠劵有BUG, 这一版本不能累加
      # order.coupons.each { |coupon| self.coupons << coupon }
    end
  end

  # TODO: need add some test to make logic is right, then make this method private.
  def merge_pending_orders
    original_order = find_original_order
    pending_orders = original_order.find_pending_orders
    # 合并订单产品
    original_order.merge_line_items(pending_orders)
    original_order.calculate_payment_total_with_pending_orders(pending_orders)
    original_order.calculate_item_total
    # FIX ME: 如果两张订单都用优惠劵的话计算错误
    # 优惠劵
    coupon_ids = original_order.coupons.collect(&:to_param)
    original_order.calculate_total_by_coupons(coupon_ids, false)
    pending_orders.destroy_all
  end

  # 1. create order
  # 2. order item total == 0
  #   1. origin order include gift => create order
  #   2. origin order exclude gift
  #   -- A
  #     1. order pay type == origin pay type
  #       1. origin order confim by servicer => create order
  #       2. origin order NOT confim by servicer => merge order
  #     2. order pay type != origin pay type => crete order
  # 3. order item total != 0
  #   -- A
  #     1. order pay type == origin pay type
  #       1. origin order confim by servicer => create order
  #       2. origin order NOT confim by servicer => merge order
  #     2. order pay type != origin pay type => crete order
  def need_merge?
    original_order = find_original_order
    pending_orders = original_order.find_pending_orders
    # 没有等待合并的订单
    return false if pending_orders && pending_orders.size.zero?
    # 本订单只含0元购，其他订单包含0元购，两个订单不合并，创建新订单
    return false if item_total == 0 && original_order.has_gift?
    # 支付方式不同则不合并
    return false if pay_type != original_order.pay_type
    true
  end

  module ClassMethods
  end
end
