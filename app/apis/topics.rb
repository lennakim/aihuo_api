class Topics < Grape::API
  resources 'topics' do

    desc "Return topics list for all nodes."
    params do
      optional :filter, type: Symbol, values: [:best, :checking, :hot, :new, :mine, :followed], default: :mine, desc: "Filtering topics."
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
      when :followed
        Topic.favorites_by_device(params[:device_id])
      end
      @topics = paginate(topics.order("top DESC, updated_at DESC"))
    end

    desc "Delete multiplea topics."
    params do
      requires :device_id, type: String, desc: "Device ID."
      requires :topic_ids, type: Array, desc: "Topis IDs."
    end
    delete "/" do
      @topics = Topic.find(params[:topic_ids])
      @topics.each do |topic|
        if topic.can_destroy_by?(params[:device_id])
          topic.destroy_by(params[:device_id])
          status 204
        else
          error! "Access Denied", 401
        end
      end
    end

    desc 'Unfollow multiplea topics.'
    params do
      requires :device_id, type: String, desc: "Device ID."
      requires :topic_ids, type: Array, desc: "Topis IDs."
    end
    delete :unfollow do
      @topics = Topic.find(params[:topic_ids])
      @topics.each do |topic|
        Favorite.by_device_id(params[:device_id]).by_favable(topic).destroy_all
      end
      status 204
    end

    params do
      requires :id, type: String, desc: "Topic id."
    end
    route_param :id do

      before do
        @topic = Topic.find(params[:id]) rescue nil
      end

      desc "Return a topic."
      get "/", jbuilder: 'topics/topic'  do
        cache(key: [:v2, :topic, params[:id]], expires_in: 2.days) do
          error!('帖子已经被帖主删除', 404) unless @topic
          @topic
        end
      end

      desc "Delete a topic."
      params do
        requires :device_id, type: String, desc: "Device ID."
      end
      delete "/" do
        if @topic.can_destroy_by?(params[:device_id])
          @topic.destroy_by(params[:device_id])
          status 204
        else
          error! "Access Denied", 401
        end
      end

      desc "Like a topic."
      put :like, jbuilder: 'topics/topic' do
        @topic.liked
        status 201
      end

      desc 'Unlike a topic.'
      put :dislike, jbuilder: 'topics/topic' do
        @topic.disliked
        status 201
      end

      desc "Follow a topic."
      params do
        requires :device_id, type: String, desc: "Device ID."
      end
      put :follow, jbuilder: 'topics/topic' do
        Favorite.find_or_create_by(favable: @topic, device_id: params[:device_id])
        @topic
        status 201
      end

      desc 'Unfollow a topic.'
      params do
        requires :device_id, type: String, desc: "Device ID."
      end
      delete :unfollow do
        Favorite.by_device_id(params[:device_id]).by_favable(@topic).destroy_all
        status 204
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
