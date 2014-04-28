module CoinRule
  extend ActiveSupport::Concern

  included do
    # after_create :increase
    # after_create :reduce
  end

  private

  def increase
    case self # means case self.class
    when Member
      # 绑定手机号增加15金币
      self.update_column(:coin_total, coin_total + 15)
    end
  end

  def reduce
    case self # means case self.class
    when PrivateMessage
      # 发送一条小纸条扣5金币
      self.sender.update_column(:coin_total, self.sender.coin_total - 5)
    end
  end

  module ClassMethods
  end
end
