class Nodes < Grape::API
  helpers NodesHelper

  resources 'nodes' do
    desc "Return public nodes list."
    params do
      use :nodes
    end
    get "/", jbuilder: 'nodes/nodes' do
      @nodes = Node.by_state(:public).by_filter(params[:filter], member_id)
    end

    params do
      requires :id, type: String, desc: "Node ID."
    end
    route_param :id do

      before do
        begin
          @node = Node.find(params[:id])
        rescue Exception => e
          error! "Node not found", 422
        end
      end

      desc "Return roles, also to check a device is node manager or not."
      params do
        requires :device_id, type: String, desc: "Device ID."
      end
      get :check_role do
        role = @node.manager_list.include?(params[:device_id]) ? "node_manager" : "user"
        { role: role }
      end

      desc "Block a user in node."
      params do
        use :block_a_user
      end
      post :block_user do
        obj = eval(params[:object_type].to_s.capitalize).find(params[:object_id])
        response = @node.block_user(params[:device_id], obj.device_id)
        if response
          status 201
        else
          status 200
        end
        { success: response }
      end

      desc "Join a group"
      params do
        use :join_or_quit
      end
      post :join, jbuilder: 'nodes/node' do
        current_member
        if sign_approval? && @member.authenticate?(params[:member][:password])
          @member.nodes << @node
        else
          error! "Access Denied", 401
        end
      end


      desc "Quit a group"
      params do
        use :join_or_quit
      end
      post :quit, jbuilder: 'nodes/node' do
        current_member
        if sign_approval? && @member.authenticate?(params[:member][:password])
          @member.nodes.delete @node
        else
          error! "Access Denied", 401
        end
      end

      resources 'topics' do
        params do
          use :topics
        end
        get "/", jbuilder: 'topics/topics' do
          cache(key: cacke_key, expires_in: 1.minutes) do
            topics = @node.topics.scope_by_filter(params[:filter], params[:device_id])
            @topics = paginate(topics.order("top DESC, updated_at DESC"))
          end
        end

        desc "Create a topic to the node."
        params do
          use :create_topic
        end
        post "/", jbuilder: 'topics/topic' do
          if sign_approval?
            @topic = @node.topics.new(topic_params)
            if params[:member]
              @topic.relate_to_member_with_authenticate(
                params[:member][:id],
                params[:member][:password]
              )
            end
            status 422 unless @topic.save
          else
            error! "Access Denied", 401
          end
        end
      end

    end
  end
end
