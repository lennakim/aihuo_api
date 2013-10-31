require 'encrypted_id_finder'
class Order < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  encrypted_id key: 'bYqILlFMZn3xd8Cy'
  # includes ..................................................................
  include EncryptedIdFinder
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  has_many :line_items
  accepts_nested_attributes_for :line_items
  has_many :comments
  has_many :orderlogs
  has_many :short_messages
  # validations ...............................................................
  validates :device_id, presence: true
  validates :name, presence: true
  validates :phone, presence: true
  validates :shipping_charge, presence: true, numericality: true
  # callbacks .................................................................
  before_destroy :logging_action
  after_create :calculate_item_total
  after_create :send_confirm_sms
  after_create :destroy_cart
  # scopes ....................................................................
  scope :by_filter, ->(filter) { filter == :rated ? with_comments : self }
  scope :with_comments, -> { joins(:comments) }
  scope :newly, -> { where(state: "订单已下，等待确认") }
  scope :done, -> { where("state = ? OR state = ?", "客户拒签，原件返回", "客户签收，订单完成") }
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def number
    created_at.to_i.to_s + (id * 2 + 19871030).to_s
  end

  # 订单总价兼容新版本用户查看旧版订单
  def total
    total = item_total.zero? ? price : item_total
    return (total + shipping_charge).to_f
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def logging_action
    orderlogs.logging_action(:delete, device_id)
  end

  # for update order on api and back end.
  def calculate_item_total
    item_total = line_items.inject(0){ |sum, item| sum + item.sale_price * item.quantity }
    update_attribute(:item_total, item_total)
  end

  # 创建订单成功则发送手机短信息
  def send_confirm_sms
    ShortMessage.send_confirm_sms(self)
  end

  def destroy_cart
  end
end
