class PrivateMessages < Grape::API
  helpers do
    def private_message_params
      receiver_id =
        Member.decrypt(
          Member.encrypted_id_key,
          params[:private_message][:receiver_id]
        )
      sender_id =
        Member.decrypt(
          Member.encrypted_id_key,
          params[:member_id]
        )
      params[:private_message][:receiver_id] = receiver_id
      params[:private_message][:sender_id] = sender_id
      # http://qiita.com/milkcocoa/items/8d827ac92b179c8aa7e4
      # https://github.com/intridea/grape/issues/404
      declared(params, include_missing: false)[:private_message]
    end

    def user_id
      Member.decrypt(Member.encrypted_id_key, params[:member_id])
    end

    def decrypt_private_message_ids
      decrypt = Proc.new do |ids, id|
        ids << PrivateMessage.decrypt(PrivateMessage.encrypted_id_key, id)
      end
      params[:ids].inject([], &decrypt)
    end

  end

  resources 'private_messages' do

    desc "Listing private message for the user."
    params do
      requires :member_id, type: String, desc: "Member ID."
      requires :password, type: String, desc: "Member Password."
      requires :filter, type: Symbol, values: [:inbox, :spam], default: :inbox, desc: "Message Type."
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get '/', jbuilder: 'private_messages/messages' do
      if authenticate?
        @private_messages =
          paginate(PrivateMessage.by_filter(params[:filter]).by_receiver(user_id))
      else
        error! "Access Denied", 401
      end
    end

    desc "Listing private message for the user."
    params do
      requires :member_id, type: String, desc: "Member ID."
      requires :password, type: String, desc: "Member Password."
      requires :friend_id, type: String, desc: "Friend ID."
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get '/history', jbuilder: 'private_messages/messages' do
      if authenticate?
        member_id = Member.decrypt(Member.encrypted_id_key, params[:member_id])
        friend_id = Member.decrypt(Member.encrypted_id_key, params[:friend_id])
        @private_messages = paginate(PrivateMessage.unscoped.history(member_id, friend_id))
      else
        error! "Access Denied", 401
      end
    end

    desc "Delete private messages by ids."
    params do
      requires :member_id, type: String, desc: "Member ID."
      requires :password, type: String, desc: "Member Password."
      optional :ids, type: Array, desc: "Private Messages ids."
    end
    delete "/" do
      if authenticate?
        PrivateMessage.delete_history_by_ids(decrypt_private_message_ids, user_id)
        status 202
      else
        error! "Access Denied", 401
      end
    end

    desc "Create a private message."
    params do
      requires :sign, type: String, desc: "Sign value"
      group :private_message, type: Hash do
        requires :body, type: String, desc: "Private message content."
        requires :receiver_id, type: String, desc: "Receiver id."
        optional :sender_id, type: String, desc: "Sender id."
      end
      requires :member_id, type: String, desc: "Member ID."
      requires :password, type: String, desc: "Member Password."
    end
    post "/", jbuilder: 'private_messages/message' do
      if sign_approval? && authenticate?
        @private_message = PrivateMessage.new(private_message_params)
        error!(@private_message.errors.values.join, 500) unless @private_message.save
      else
        error! "Access Denied", 401
      end
    end

    params do
      requires :id, type: String, desc: "Message ID."
    end
    route_param :id do
      desc "Return a message."
      get "/", jbuilder: 'private_messages/message' do
        @private_message = PrivateMessage.find(params[:id])
        @private_message.opened!
      end
    end

  end
end
