module CommentsHelper
  extend Grape::API::Helpers

  def current_member
    @member = Member.find(params[:member_id]) if params[:member_id]
    @device = Device.where(device_id: params[:device_id]).first if params[:device_id]
    @member ||= Member.where(id: @device.member_id).first if @device
    @member
  end

  def have_this_order? order
    current_member
    if @device
      error!("user don't have this order", 401) unless order && @device.device_id == order.device_id
    elsif @member
      error!("user don't have this order", 401) unless order && @member.phone == order.phone
    end
    true
  end


  params :comment_member_relate do
    optional :member_id, type: Integer, desc: "id of order or line_item"
    optional :device_id, type: Integer, desc: "id of order or line_item"
    exactly_one_of :device_id, :member_id
  end

  def get_comment order_or_item
    if comment_hash = order_or_item[:line_item]
      line_item = LineItem.find params[:id]
      params_validates line_item
      #组装数据
      combine_comment_of_line_item(comment_hash, line_item, )

      # comment_hash[:id] = order_or_item[:id]
      result_hash = turn_string_to_sym_hash(comment_hash)
      line_item.create_comment(result_hash)

    elsif order_hash = order_or_item[:order]
      order = Order.find params[:id]
      params_validates order

      combine_comment_of_line_item(comment_hash, order)

      order_hash = turn_string_to_sym_hash(order_hash)
      order.create_order_comment order_hash
    end
  end

  #验证 order 或者 line_item 是否符合添加评论的条件
  def params_validates order_or_item
    if order_or_item.is_a? LineItem
      error!('不能提供修改评论功能', 401) unless order_or_item && (!order_or_item.comment) && have_this_order?(order_or_item.order)
    elsif order_or_item.is_a? Order
      error!('不能提供修改评论功能', 401) unless order_or_item && (!order_or_item.order_comment) && have_this_order?(order_or_item)
    else
       error!('不能提供修改评论功能', 401)
    end
    true
  end

  #组合 line_itme 生成评论需要的 hash 数值
  def combine_comment_of_line_item(comment_hash, line_item)
    if line_item.is_a? LineItem
      comment_hash[:product_id] = line_item.product.try(:id)
      comment_hash[:order_id] = line_item.order.try(:id)
      comment_hash[:name] = @member.handled_nickname
      comment_hash[:comment_at] = Time.now
      comment_hash[:device_id] = line_item.order.try(:device_id)
      comment_hash
    elsif line_item.is_a? Order
      comment_hash[:comment_at] = Time.now
      comment_hash[:device_id] = order.try(:device_id)
      comment_hash
    end
  end

  def turn_string_to_sym_hash hash
    hash.each_with_object({}){|(key, value), hash| hash[key.to_sym] = value}
  end

  def combine_comment_public(comment_hash, device_id)
    comment_hash[:comment_at] = Time.now
    comment_hash[:device_id] = device_id
  end
end
