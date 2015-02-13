class Replies < Grape::API
  resources 'replies' do

    desc "Listing replies for the user."
    params do
      requires :device_id, type: String, desc: "Device ID."
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get '/', jbuilder: 'replies/replies' do
      current_device_id
      @replies = paginate(Reply.to_me(params[:device_id]))
    end

    params do
      requires :id, type: String, desc: "Reply ID."
    end
    route_param :id do

      before do
        @reply = Reply.find(params[:id])
      end

      desc "Destroy a reply."
      delete "/", jbuilder: 'replies/reply' do
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
        optional :member, type: Hash do
          requires :id, type: String, desc: "Member ID."
          requires :password, type: String, desc: "Member password."
        end
      end
      post "/", jbuilder: 'replies/reply' do
        if sign_approval?
          @reply = @reply.replies.new({
                     body: params[:body],
                     nickname: params[:nickname],
                     device_id: params[:device_id]
                   })
          if params[:member]
            @reply.relate_to_member_with_authenticate(
              params[:member][:id],
              params[:member][:password]
            )
          end
          status 422 unless @reply.save
        else
          error! "Access Denied", 401
        end
      end

    end

  end
end
