module TopicsHelper
  extend Grape::API::Helpers

  params :topics do
    optional :filter, type: Symbol, values: [:recommend, :best, :checking, :hot, :new, :mine, :followed], default: :mine, desc: "Filtering topics."
    requires :device_id, type: String, desc: "Device ID."
    optional :page, type: Integer, default: 1, desc: "Page number."
    optional :per_page, type: Integer, default: 10, desc: "Per page value."
  end

  params :manage_multiplea_topics do
    requires :device_id, type: String, desc: "Device ID."
    requires :topic_ids, type: Array, desc: "Topis IDs."
  end

  params :replies do
    optional :page, type: Integer, default: 1, desc: "Page number."
    optional :per_page, type: Integer, default: 10, desc: "Per page value."
    optional :sort, type: Symbol, values: [:asc, :desc], default: :asc, desc: "Sort value."
  end

  params :reply do
    requires :body, type: String, desc: "Reply content."
    requires :nickname, type: String, desc: "User nickname."
    requires :device_id, type: String, desc: "Deivce ID."
    requires :sign, type: String, desc: "sign value."
    optional :member, type: Hash do
      requires :id, type: String, desc: "Member ID."
      requires :password, type: String, desc: "Member password."
    end
  end

  def reply_params
    params[:reply] = Hash.new
    params[:reply][:body] = params[:body]
    params[:reply][:nickname] = params[:nickname]
    params[:reply][:device_id] = params[:device_id]
    # params[:topic].class is Hashie::Mash,
    # and therefore triggering this behavior in ForbiddenAttributesProtection
    # so we make it as standard Hash.
    params[:reply].to_h
  end

  def current_device_id
    @current_device_id = request.headers["Device-Id"] || params[:device_id]
  end

  def cacke_key
    key = [:v2, :topic, params[:filter], params[:page], params[:per_page]]
    key.push(params[:device_id]) if [:mine, :followed].include? params[:filter]
    key
  end
end
