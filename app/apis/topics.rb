class Topics < Grape::API
  helpers TopicsHelper

  resources 'topics' do
    desc "Return topics list for all nodes."
    params do
      use :topics
    end
    get "/", jbuilder: 'topics/topics' do
      current_application
      topics = Topic.scope_by_filter(params[:filter], params[:device_id], @application)
      @topics = paginate(topics.order("top DESC, updated_at DESC"))
    end

    desc "Delete multiplea topics."
    params do
      use :manage_multiplea_topics
    end
    delete "/" do
      @topics = Topic.with_deleted.find_by_encrypted_id(params[:topic_ids])
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
      use :manage_multiplea_topics
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
        begin
          @topic = Topic.with_deleted.find_by_encrypted_id(params[:id])
        rescue Exception => e
          error! "Topic not found", 404
        end
      end

      desc "Return a topic."
      get "/", jbuilder: 'topics/topic'  do
        error!('帖子已经被帖主删除', 404) unless @topic
        @topic
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

      desc "Repost a topic."
      params do
        requires :device_id, type: String, desc: "Device ID."
      end
      put :forward, jbuilder: 'topics/topic' do
        @topic.forward
        status 202
      end

      resources 'replies' do
        desc "Return a listing of replies for a topic."
        params do
          use :replies
        end
        get "/", jbuilder: 'replies/replies' do
          @replies = paginate(@topic.replies.sort(params[:sort]))
        end

        desc "Create a reply to the topic."
        params do
          use :reply
        end
        post "/", jbuilder: 'replies/reply' do
          verify_sign
          @reply = @topic.replies.new(reply_params)
          if params[:member]
            @reply.relate_to_member_with_authenticate(
              params[:member][:id],
              params[:member][:password]
            )
          end
          status 422 unless @reply.save
        end
      end

    end

  end
end
