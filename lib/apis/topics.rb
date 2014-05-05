class Topics < Grape::API
  resources 'topics' do

    desc "Return topics list for all nodes."
    params do
      optional :filter, type: Symbol, values: [:best, :checking, :hot, :new, :mine], default: :mine, desc: "Filtering topics."
      requires :device_id, type: String, desc: "Device ID."
      optional :page, type: Integer, default: 1, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end

    get "/", jbuilder: 'topics/topics' do
      topics = case params[:filter]
      when :best
        Topic.approved.excellent
      when :checking
        Topic.checking
      when :hot
        Topic.approved.popular
      when :new
        Topic.approved.lasted
      when :mine
        Topic.with_deleted.by_device(params[:device_id])
      end
      @topics = paginate(topics.order("top DESC, updated_at DESC"))
    end

    params do
      requires :id, type: String, desc: "Topic id."
    end
    route_param :id do

      before do
        @topic = Topic.find_by_encrypted_id(params[:id])
      end

      desc "Return a topic."
      get "/", jbuilder: 'topics/topic'  do
        cache(key: [:v2, :topic, @topic], expires_in: 2.days) do
          @topic
        end
      end

      desc "Delete a topic."
      params do
        requires :device_id, type: String, desc: "Device ID."
      end
      delete "/", jbuilder: 'topics/topic' do
        if @topic.can_destroy_by?(params[:device_id])
          @topic.destroy_by(params[:device_id])
          status 202
        else
          error! "Access Denied", 401
        end
      end

      desc "Like a topic."
      put :like, jbuilder: 'topics/topic' do
        @topic.liked
        status 202
      end

      desc 'Unlike a topic.'
      put :dislike, jbuilder: 'topics/topic' do
        @topic.disliked
        status 202
      end

      resources 'replies' do
        desc "Return a listing of replies for a topic."
        params do
          optional :page, type: Integer, default: 1, desc: "Page number."
          optional :per_page, type: Integer, default: 10, desc: "Per page value."
        end
        get "/", jbuilder: 'replies/replies' do
          @replies = paginate(@topic.replies)
        end

        desc "Create a reply to the topic."
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
            @reply = @topic.replies.new({
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
