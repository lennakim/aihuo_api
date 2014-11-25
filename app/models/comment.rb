class Comment < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  # includes ..................................................................
  include EncryptedId
  # relationships .............................................................
  belongs_to :order
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { where(:enabled => true).order("id DESC") }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'vL6dUuuJn0yLMdYd'
  belongs_to :commable, polymorphic: true

  DEFAULT_SCORE = 5
  # class methods .............................................................
  after_initialize :set_comment_time
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  def handled_score
    score || DEFAULT_SCORE
  end

  def set_comment_time
    self.comment_at = Time.now
  end

  #组合 line_itme 生成评论需要的 hash 数值
  def self.combine_comment_of_line_item(comment_hash, line_item_or_order)
    if line_item_or_order.is_a? LineItem
      comment_hash[:product_id] = line_item_or_order.product.try(:id)
      comment_hash[:order_id] = line_item_or_order.order.try(:id)
      order_member_name = line_item_or_order.order.try(:name)
      comment_hash[:name] = Member::masked_nickname(order_member_name)
      comment_hash[:device_id] = line_item_or_order.order.try(:device_id)
    elsif line_item_or_order.is_a? Order
      comment_hash[:order_id] = line_item_or_order.try(:id)
      order_member_name = line_item_or_order.try(:name)
      comment_hash[:name] = Member::masked_nickname(order_member_name)
      comment_hash[:device_id] = line_item_or_order.try(:device_id)
    end
    comment_hash
  end

  def product_quality_score
    score || DEFAULT_SCORE
  end
end
