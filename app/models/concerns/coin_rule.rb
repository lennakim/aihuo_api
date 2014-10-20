module CoinRule
  extend ActiveSupport::Concern

  included do
    validate :coin_must_enough
    after_create :reduce_coin, :increase_coin
  end

  module ClassMethods
  end

  private

  def increase_coin
    case self
    when Member
      # 注册就送5金币
      increase_coins(5)
    end
  end

  def reduce_coin
    case self
    when PrivateMessage
      # 陌生的两个人首次发送一条小纸条扣5金币
      # 接收者回复纸条不扣金币，发送者再次发送仍然扣金币
      reduce_coins(5) unless friendly_to_receiver?
    end
  end

  def increase_coins(coin = 5)
    get_member
    if @member
      @member.update_column(:coin_total, @member.coin_total + coin)
    end
  end

  def reduce_coins(coin = 5)
    get_member
    if @member
      @member.update_column(:coin_total, @member.coin_total - coin)
    end
  end

  def get_member
    @member =
      case self
      when Member then self
      when TaskLogging then self.member
      when PrivateMessage then self.sender
      end
  end

  # 发送小纸条前验证用户余额
  def coin_must_enough
    case self
    when PrivateMessage
      if sender.coin_total < 5 && !friendly_to_receiver?
        errors.add(:member_id, "发送失败，金币不足")
      end
    end
  end

end
