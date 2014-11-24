module CommentsHelper
  extend Grape::API::Helpers

  params :comment_member_relate do
    optional :member, type: Hash, desc: "if have the member info" do
      requires :id , type: String
      requires :password, type: String
    end
    optional :device_id, type: String, desc: "if have the device info"
    at_least_one_of :device_id, :member
  end

  def create_comment order_or_item_params
    object_class_name = params[:type].split("_").inject(""){|combine_str, i_str| combine_str << i_str.capitalize}

    object =  object_class_name.constantize.find params[:id]
    public_key = ["score", "content"]
    public_params = order_or_item_params.select {|key, value| public_key.include? key }
    Comment::combine_comment_of_line_item(public_params, object)
    result_hash = turn_string_to_sym_hash(public_params)
    if order_or_item_params[:type] == "order"
      object.create_order_comment(result_hash)
    elsif order_or_item_params[:type] == "line_item"
      object.create_comment(result_hash)
    end
  end

  def current_member
    if params[:member]
      member = Member.find(params[:member][:id])
      #need to vertify the password of a member
      @member = member
    end
    @device = Device.where(device_id: params[:device_id]).first if params[:device_id]
    @member ||= Member.where(id: @device.member_id).first if @device
    error!("use do not have this device") if @device && @member && (@device.member_id != @member.id)
    @member
  end

  def have_this_order? order
    current_member
    if @device
      error!("user don't have this order", 401) unless order && @device.device_id == order.device_id
    elsif @member
      error!("user don't have this order", 401) unless order && @member.phone == order.phone
    else
      error!("use id is error")
    end
    true
  end

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

  def turn_string_to_sym_hash hash
    hash.each_with_object({}){|(key, value), hash| hash[key.to_sym] = value}
  end

    # if order_or_item[:type] == "line_item"

    #   line_item = LineItem.find params[:id]
    #   params_validates line_item
    #   #组装数据
    #   combine_comment_of_line_item(order_or_item_params, line_item)

    #   result_hash = turn_string_to_sym_hash(order_or_item_params)
    #   line_item.create_comment(result_hash)

    # elsif order_or_item[:type] == "order"
    #   order = Order.find params[:id]
    #   params_validates order

    #   combine_comment_of_line_item(order_or_item_params, order)

    #   order_hash = turn_string_to_sym_hash(order_or_item_params)
    #   order.create_order_comment order_hash
    # end


  #验证 order 或者 line_item 是否符合添加评论的条件

  #组合 line_itme 生成评论需要的 hash 数值
  # def combine_comment_of_line_item(comment_hash, line_item)
  #   if line_item.is_a? LineItem
  #     comment_hash[:product_id] = line_item.product.try(:id)
  #     comment_hash[:order_id] = line_item.order.try(:id)
  #     comment_hash[:name] = @member.try(:handled_nickname)
  #     comment_hash[:device_id] = line_item.order.try(:device_id)
  #   elsif line_item.is_a? Order
  #     comment_hash[:order_id] = line_item.try(:id)
  #     comment_hash[:name] = @member.try(:handled_nickname)
  #     comment_hash[:device_id] = line_item.try(:device_id)
  #   end
  #   comment_hash
  # end

end
