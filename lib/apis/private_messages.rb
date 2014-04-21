class PrivateMessages < Grape::API
  helpers do
    def private_message_params
      receiver_id =
        EncryptedId.decrypt(
          Member.encrypted_id_key,
          params[:private_message][:receiver_id]
          )
      sender_id =
        EncryptedId.decrypt(
          Member.encrypted_id_key,
          params[:private_message][:sender_id]
        )
      params[:private_message][:receiver_id] = receiver_id
      params[:private_message][:sender_id] = sender_id
      # http://qiita.com/milkcocoa/items/8d827ac92b179c8aa7e4
      # https://github.com/intridea/grape/issues/404
      declared(params, include_missing: false)[:private_message]
    end

    def receiver_param
      EncryptedId.decrypt(Member.encrypted_id_key, params[:member_id])
    end
  end


  resources 'private_messages' do

    desc "Listing private message for the user."
    params do
      requires :member_id, type: String, desc: "Member ID."
      requires :filter, type: Symbol, values: [:inbox, :spam], default: :inbox, desc: "Message Type."
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end

    get '/', jbuilder: 'private_messages/messages' do
        messages = case params[:filter]
        when :inbox
          PrivateMessage
        when :spam
          PrivateMessage.unscoped.spam
        end
      @private_messages = paginate(messages.by_receiver(receiver_param))
    end

    desc "Create a private message."
    params do
      requires :sign, type: String, desc: "Sign value"
      group :private_message, type: Hash do
        requires :body, type: String, desc: "Private message content."
        requires :receiver_id, type: String, desc: "Receiver id."
        requires :sender_id, type: String, desc: "Sender id."
      end
    end

    post "/", jbuilder: 'private_messages/message' do
      if sign_approval?
        @private_message = PrivateMessage.new(private_message_params)
        @private_message.save
      else
        error! "Access Denied", 401
      end
    end



  end
end
