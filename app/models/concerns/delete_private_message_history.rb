module DeletePrivateMessageHistory
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def delete_history_by_ids(ids, user_id)
      messages = where(id: ids)
      delete_msg = Proc.new { |msg| msg.delete_history_by(user_id) }
      messages.each(&delete_msg)
    end
  end

  def delete_history_by(user_id)
    messages = PrivateMessage.full_history(sender_id, receiver_id)
    delete_msg = Proc.new { |msg| msg.delete_by(user_id.to_i) }
    messages.each(&delete_msg)
  end

  protected

  def delete_by(user_id)
    delete_by_sender! if sender_id === user_id
    delete_by_receiver! if receiver_id === user_id
  end

  def delete_by_sender!
    update_attribute(:sender_delete, true)
  end

  def delete_by_receiver!
    update_attribute(:receiver_delete, true)
  end

end
