module TouchTopic
  extend ActiveSupport::Concern

  included do
    set_callback :create, :after, :touch_topic, if: -> { self.class == Reply }
  end

  protected
  # 帖子创建时间在5天内的，更新 updated_at
  def save_and_touch_topic_updated_at
    case self
    when Reply
      if topic.created_at > 5.days.ago(Date.today)
        topic.updated_at = Time.now
        topic.save(validate: false)
      end
    when Topic
      if created_at > 5.days.ago(Date.today)
        self.updated_at = Time.now
        save(validate: false)
      end
    end
  end

  alias_method :touch_topic, :save_and_touch_topic_updated_at
end
