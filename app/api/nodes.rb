module API
  class Nodes < Grape::API
    resources 'nodes' do
      desc "Return public nodes list."
      params do
        optional :page, type: Integer, default: 1, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Per page value."
      end
      get "/", jbuilder: 'nodes/nodes' do
        @nodes = Node.public.page(params[:page]).per(params[:per])
      end

      params do
        requires :id, type: String, desc: "Node ID."
      end
      route_param :id do
        desc "Return roles, also to check a device is node manager or not."
        params do
          requires :device_id, type: String, desc: "Device ID."
        end
        get :check_role do
          node = Node.find(params[:id])
          role = node.manager_list.include?(params[:device_id]) ? "node_manager" : "user"
          { role: role }
        end

      end
    end
  end
end
