module ScoreRule
  extend ActiveSupport::Concern

  included do
    after_create :increase_score
  end

  module ClassMethods
  end

  private

  def increase_score
    case self
    when Reply then increase_points(1) # 回复帖子奖励 1 积分
    end
  end

  def increase_points(point = 1)
    get_member
    if @member
      @member.update_column(:score_total, @member.score_total + point)
      update_level if should_update_level?
    end
  end

  def reduce_points(point = 0); end

  def get_member
    @member =
      case self
      when Member then self
      when Reply then self.member
      end
  end

  def should_update_level?
    @member.score_total >= maximum_points_for_level(@member.next_level)
  end

  def update_level
    @member.update_column(:level, @member.level + 1)
  end

  def maximum_points_for_level(level)
    # same as: level * (level + 1) / 2 * 10
    (0..level).inject(0) { |sum, level| sum + level * 10 }
  end

end
