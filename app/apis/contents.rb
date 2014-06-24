class Contents < Grape::API
  helpers do
  end

  resources 'contents' do

    desc "Listing contents."
    params do
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get "/", jbuilder: 'contents/contents' do
      cache(key: [:v2, :contents, params[:page], params[:per_page]], expires_in: 5.minutes) do
        @contents = paginate(Content)
      end
    end

    params do
      requires :id, type: String, desc: "Content id."
    end
    route_param :id do

      before do
        @content = Content.find(params[:id])
      end

      desc "Return a content."
      get "/", jbuilder: 'contents/content'  do
        cache(key: [:v2, :content, @content], expires_in: 5.minutes) do
          @content
        end
      end

      desc "Like a content."
      put :like, jbuilder: 'contents/content' do
        @content.liked
        status 202
      end

      desc 'Unlike a content.'
      put :dislike, jbuilder: 'contents/content' do
        @content.disliked
        status 202
      end

      desc "Repost a content"
      put :forward, jbuilder: 'contents/content' do
        @content.forward
        status 202
      end

      resources 'replies' do
        desc "Return a listing of replies for a content."
        params do
          optional :page, type: Integer, default: 1, desc: "Page number."
          optional :per_page, type: Integer, default: 10, desc: "Per page value."
        end
        get "/", jbuilder: 'replies/replies' do
          @replies = paginate(@content.replies)
        end

        desc "Create a reply to the content."
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
            @reply = @content.replies.new({
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
end
