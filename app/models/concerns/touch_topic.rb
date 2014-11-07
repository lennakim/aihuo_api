module TouchTopic
  extend ActiveSupport::Concern

  included do
    set_callback :create, :after, :touch_topic, if: -> { self.class == Reply }
  end

  protected
  # 帖子创建时间在5天内的，更新 updated_at
  def save_and_touch_topic_updated_at
    object =
      case self
      when Reply then topic
      when Topic then self
      end

    if object.created_at > 5.days.ago(Date.today)
      object.updated_at = Time.now
      object.save(validate: false)
    end
  end

  alias_method :touch_topic, :save_and_touch_topic_updated_at
end
