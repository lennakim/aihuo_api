class Replies < Grape::API
  resources 'replies' do

    params do
      requires :id, type: String, desc: "Reply ID."
    end
    route_param :id do
      desc "Destroy a reply."
      delete "/", jbuilder: 'replies/reply' do
        @reply = Reply.find(params[:id])
        if @reply.can_destroy_by?(params[:device_id])
          @reply.destroy
          status 202
        else
          error! "Access Denied", 401
        end
      end

      desc "Create a reply to the reply."
      params do
        requires :body, type: String, desc: "Reply content."
        requires :nickname, type: String, desc: "User nickname."
        requires :device_id, type: String, desc: "Deivce ID."
        requires :sign, type: String, desc: "sign value."
      end
      post "/", jbuilder: 'replies/reply' do
        if sign_approval?
          reply = Reply.find(params[:id])
          @reply = reply.replies.new({ body: params[:body], nickname: params[:nickname], device_id: params[:device_id] })
          status 422 unless @reply.save
        else
          error! "Access Denied", 401
        end
      end
    end

  end
end
