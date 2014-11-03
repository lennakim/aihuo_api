module ForumValidations
  extend ActiveSupport::Concern

  included do
    validates_presence_of :body

    validate on: :create do
      error_msg = "您因违规，已被禁言，请到商城答疑小组找管理员申诉。"
      errors.add(:device_id, error_msg) if Blacklist.available.find_by(device_id: device_id, node_id: 0)
      errors.add(:device_id, error_msg) if Blacklist.find_by(device_id: device_id, node_id: node_id)
    end

    # validate on: :create do
    #   error_msg = "内容包含敏感词，有问题请去版务区发帖申诉"
    #   ban_words = (Setting.find_by_name("ban_words").value || "").split("\n")
    #   ban_words.each do |word|
    #     errors.add(:body, error_msg) if body.strip.downcase.include?(word.strip.downcase)
    #   end
    # end

    # user parameter is a device id.
    def can_destroy_by?(user)
      # Reply object try to return its topic device.
      owner = try(:topic).try(:device_id) || try(:device_id)
      user.present? && (user == owner || node.manager_list.include?(user))
    end
  end
end
