module CommentsHelper
  extend Grape::API::Helpers

  params :comment do
    requires :device_id, type: String, desc: "if have the device info"
    requires :sign, type: String, desc: "Sign value"
    requires :id, type: String, desc: "id of order or line_item"
    requires :type, type: String, desc: "decide is the order or line_item"
    requires :score, type: Integer, desc: "comment score", values: (0..5).to_a
    optional :content, type: String, desc: "comments content"
  end


  def create_comment order_or_item_params
    object_class_name = params[:type].split("_").inject(""){|combine_str, i_str| combine_str << i_str.capitalize}
    #获得相应对象
    object =  object_class_name.constantize.find params[:id]
    params_validates object
    #hash 过滤
    public_key = ["score", "content"]
    public_params = order_or_item_params.select {|key, value| public_key.include? key }
    #组合 hash 参数
    Comment::combine_comment_of_line_item(public_params, object)
    result_hash = turn_string_to_sym_hash(public_params)
    #根据不同参数类型，调用不同的组合关系
    if order_or_item_params[:type] == "order"
      [object.create_order_comment(result_hash), object]
    elsif order_or_item_params[:type] == "line_item"
      [object.create_comment(result_hash), object.order]
    end
  end

  def have_this_order? order
    true if order && (order.device_id == params[:device_id])
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
end
