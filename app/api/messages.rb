module API
  class Messages < Grape::API
    helpers do
      def message_params
        params[:message][:from] = params[:device_id]
        # Decrypt object id
        if params[:message][:object_id]
          product_id = EncryptedId.decrypt(Product.encrypted_id_key, params[:message][:object_id])
          params[:message][:object_id] = product_id
        end
        # Decrypt parent id
        if params[:message][:parent_id]
          parent_id = EncryptedId.decrypt(Message.encrypted_id_key, params[:message][:parent_id])
          params[:message][:parent_id] = parent_id
        end
        # http://qiita.com/milkcocoa/items/8d827ac92b179c8aa7e4
        # https://github.com/intridea/grape/issues/404
        declared(params)[:message]
      end
    end

    resources 'messages' do
      desc "Return a messages list."
      params do
        requires :device_id, type: String, desc: "Device id."
        optional :since_id, type: String, desc: "Mesaage id."
        optional :page, type: Integer, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Per page value."
      end
      get "/", jbuilder: 'messages/messages' do
        @messages = Message.by_device(params[:device_id]).since(params[:since_id]).page(params[:page]).per(params[:per])
      end

      desc "Create a messages."
      params do
        requires :device_id, type: String, desc: "Device ID"
        requires :sign, type: String, desc: "Sign value."
        group :message do
          requires :body, type: String, desc: "Message content."
          optional :category, type: Symbol, values: [:question], default: :question, desc: "Message category."
          optional :object_id, type: String, desc: "Product id."
          optional :parent_id, type: String, desc: "Parent Message id."
          optional :from, type: String, desc: "User device_id."
        end
      end
      post "/", jbuilder: 'messages/message'  do
        if sign_approval?(declared(params, include_missing: false), params[:sign])
          @message = Message.question.new(message_params)
          status 500 unless @message.save
        else
          error! "Access Denied", 401
        end
      end
    end
  end
end

