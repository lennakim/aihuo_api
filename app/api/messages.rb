module API
  class Messages < Grape::API
    resources 'messages' do
      desc "Return a messages list for test create."
      params do
        optional :page, type: Integer, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Per page value."
      end
      get "/", jbuilder: 'messages/messages' do
        @messages = Message.roots.order("created_at DESC").page(params[:page]).per(params[:per])
      end

      desc "Create a messages."
      params do
        requires :object_id, type: String, desc: "Product id."
        requires :from, type: String, desc: "User device_id."
        requires :body, type: String, desc: "Message content."
        requires :category, type: Symbol, values: [:question], default: :question, desc: "Message category."
      end
      post do
        product = Product.find(params[:object_id])
        Message.question.create!({ body: params[:body], from: params[:from], object_id: product.id })
      end
    end
  end
end

