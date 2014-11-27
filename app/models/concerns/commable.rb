module Commable
  extend ActiveSupport::Concern

  included do
    has_one :comment, class_name: 'Comment', as: :commable
  end

  def commented?
    comment.present?
  end
end
