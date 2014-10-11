class Nodes < Grape::API
  resources 'nodes' do
    desc "Return public nodes list."
    params do
      optional :filter, type: Symbol, values: [:male, :female, :all, :joins], default: :all, desc: "Filtering topics."
      optional :member_id, type: String, desc: "Member ID."
      optional :page, type: Integer, default: 1, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get "/", jbuilder: 'nodes/nodes' do
      @nodes = paginate(Node.by_state(:public).by_filter(params[:filter], params[:member_id]))
      cache(key: [:v2, :nodes, @nodes], expires_in: 2.days) do
        @nodes
      end
    end

    params do
      requires :id, type: String, desc: "Node ID."
    end
    route_param :id do

      before do
        begin
          @node = Node.find(params[:id])
        rescue Exception => e
          error! "Node not found", 404
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
        requires :device_id, type: String, desc: "Device ID."
        requires :object_id, type: String, desc: "Object ID."
        requires :object_type, type: Symbol, values: [:topic, :reply], default: :topic, desc: "Object Type."
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
        requires :member, type: Hash do
          requires :id, type: String, desc: "Member ID."
          requires :password, type: String, desc: "Member password."
        end
        requires :sign, type: String, desc: "sign value."
      end
      post :join do
        @member = Member.find(params[:id])
        if sign_approval? && @member.authenticate?(params[:member][:password])
          @member.nodes << @node
        else
          error! "Access Denied", 401
        end
      end


      desc "Quit a group"
      params do
        requires :member, type: Hash do
          requires :id, type: String, desc: "Member ID."
          requires :password, type: String, desc: "Member password."
        end
        requires :sign, type: String, desc: "sign value."
      end
      post :quit do
        @member = Member.find(params[:id])
        if sign_approval? && @member.authenticate?(params[:member][:password])
          @member.nodes.delete @node
        else
          error! "Access Denied", 401
        end
      end

      resources 'topics' do
        params do
          optional :filter, type: Symbol, values: [:recommend, :best, :checking, :hot, :new, :mine, :followed, :all], default: :all, desc: "Filtering topics."
          requires :device_id, type: String, desc: "Device ID."
          optional :page, type: Integer, default: 1, desc: "Page number."
          optional :per_page, type: Integer, default: 10, desc: "Per page value."
        end
        get "/", jbuilder: 'topics/topics' do
          topics = @node.topics.scope_by_filter(params[:filter], params[:device_id])
          @topics = paginate(topics.order("top DESC, updated_at DESC"))
        end

        desc "Create a topic to the node."
        params do
          requires :body, type: String, desc: "Topic content."
          requires :nickname, type: String, desc: "User nickname."
          requires :device_id, type: String, desc: "Deivce ID."
          requires :sign, type: String, desc: "sign value."
          optional :member, type: Hash do
            requires :id, type: String, desc: "Member ID."
            requires :password, type: String, desc: "Member Password."
          end
        end
        post "/", jbuilder: 'topics/topic' do
          if sign_approval?
            @topic = @node.topics.new({
                       body: params[:body],
                       nickname: params[:nickname],
                       device_id: params[:device_id]
                     })
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
