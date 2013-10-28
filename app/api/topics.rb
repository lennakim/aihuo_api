module API
  class Topics < Grape::API
    resources 'topics' do
      desc "Return topics list for all nodes."
      params do
        optional :filter, type: Symbol, values: [:hot, :new, :mine], default: :mine, desc: "Filtering topics."
        requires :device_id, type: String, desc: "Device ID."
        optional :page, type: Integer, default: 1, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Per page value."
      end
      get "/", jbuilder: 'topics/topics' do
        topics = case params[:filter]
        when :hot
          Topic.popular
        when :new
          Topic.lasted
        when :mine
          Topic.by_device(params[:device_id])
        end
        @topics = topics.order("top DESC, updated_at DESC").page(params[:page]).per(params[:per])
      end

      params do
        requires :id, type: String, desc: "Topic id."
      end
      route_param :id do
        desc "Return a topic."
        get "/", jbuilder: 'topics/topic'  do
          @topic = Topic.find(params[:id])
        end

        desc "Delete a topic."
        params do
          requires :device_id, type: String, desc: "Device ID."
        end
        delete "/", jbuilder: 'topics/topic' do
          @topic = Topic.find(params[:id])
          if @topic.can_destroy_by?(params[:device_id])
            @topic.destroy_by(params[:device_id])
            status 202
          end
        end

        desc "Like a topic."
        put :like, jbuilder: 'topics/topic' do
          @topic = Topic.find(params[:id])
          @topic.liked
          status 202
        end

        desc 'Unlike a topic.'
        put :unlike, jbuilder: 'topics/topic' do
          @topic = Topic.find(params[:id])
          @topic.unliked
          status 202
        end

        resources 'replies' do
          desc "Return a listing of replies for a topic."
          params do
            optional :page, type: Integer, default: 1, desc: "Page number."
            optional :per, type: Integer, default: 10, desc: "Per page value."
          end
          get "/", jbuilder: 'replies/replies' do
            topic = Topic.find(params[:id])
            @replies = topic.replies.page(params[:page]).per(params[:per])
          end
        end
      end

    end

  end
end
