module CoinRule
  extend ActiveSupport::Concern

  included do
    # after_create :increase
    # after_create :reduce
  end

  private

  def increase(coin = 5)
    case self # means case self.class
    when Member
      self.update_column(:coin_total, coin_total + coin)
    when TaskLogging
      member = self.member
      member.update_column(:coin_total, member.coin_total + coin)
    end
  end

  def reduce(coin = 5)
    case self # means case self.class
    when PrivateMessage
      self.sender.update_column(:coin_total, self.sender.coin_total - coin)
    end
  end

  module ClassMethods
  end
end
