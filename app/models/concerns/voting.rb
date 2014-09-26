module Voting
  extend ActiveSupport::Concern

  include TouchTopic
  # public instance methods ...................................................
  def add_liked
    likes_count + 1
  end

  def add_disliked
    unlikes_count + 1
  end

  def add_forward
    forward_count + 1
  end

  def liked
    change_attribute(:likes_count, add_liked)
  end

  def disliked
    change_attribute(:unlikes_count, add_disliked)
  end

  def forward
    change_attribute(:forward_count, add_forward)
  end

  private
  def change_attribute(name, value)
    self.send(name.to_s + '=', value)
    save_and_touch_topic_updated_at
  end
end
