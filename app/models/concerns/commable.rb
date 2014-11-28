module Commable
  extend ActiveSupport::Concern

  included do
    # We can not use comment, because the orders table has save column name.
    has_one :review, class_name: 'Comment', as: :commable
  end

  def commented?
    review.present?
  end
end
