module NodesHelper
  extend Grape::API::Helpers

  params :nodes do
    optional :filter, type: Symbol, values: [:male, :female, :all, :joins], default: :all, desc: "Filtering topics."
    optional :member_id, type: String, desc: "Member ID."
    optional :page, type: Integer, default: 1, desc: "Page number."
    optional :per_page, type: Integer, default: 10, desc: "Per page value."
  end

  params :block_a_user do
    requires :device_id, type: String, desc: "Device ID."
    requires :object_id, type: String, desc: "Object ID."
    requires :object_type, type: Symbol, values: [:topic, :reply], default: :topic, desc: "Object Type."
  end

  params :join_or_quit do
    requires :member, type: Hash do
      requires :id, type: String, desc: "Member ID."
      requires :password, type: String, desc: "Member password."
    end
    requires :sign, type: String, desc: "sign value."
  end

  params :topics do
    optional :filter, type: Symbol, values: [:recommend, :best, :checking, :hot, :new, :mine, :followed, :all], default: :all, desc: "Filtering topics."
    requires :device_id, type: String, desc: "Device ID."
    optional :page, type: Integer, default: 1, desc: "Page number."
    optional :per_page, type: Integer, default: 10, desc: "Per page value."
  end

  params :create_topic do
    requires :body, type: String, desc: "Topic content."
    requires :nickname, type: String, desc: "User nickname."
    requires :device_id, type: String, desc: "Deivce ID."
    requires :sign, type: String, desc: "sign value."
    optional :topic_images_attributes, type: Hash, desc: "照片"
    optional :member, type: Hash do
      requires :id, type: String, desc: "Member ID."
      requires :password, type: String, desc: "Member Password."
    end
  end

  def topic_params
    params[:topic] = Hash.new
    params[:topic][:body] = params[:body]
    params[:topic][:nickname] = params[:nickname]
    params[:topic][:device_id] = params[:device_id]
    if params[:topic_images_attributes]
      params[:topic][:topic_images_attributes] = params[:topic_images_attributes]
    end
    # params[:topic].class is Hashie::Mash,
    # and therefore triggering this behavior in ForbiddenAttributesProtection
    # so we make it as standard Hash.
    params[:topic].to_h
  end

  def current_member
    begin
      @member = Member.find(params[:member][:id])
    rescue RecordNotFound => e
      error! "Node not found", 422
    end
  end

  def cacke_key
    key = [
      :v2, :node, params[:id], :topics, params[:filter],
      params[:page], params[:per_page]
    ]
    key.push(params[:device_id]) if [:mine, :followed].include? params[:filter]
    key
  end

  def member_id
    Member.decrypt(Member.encrypted_id_key, params[:member_id]) if params[:member_id]
  end
end
