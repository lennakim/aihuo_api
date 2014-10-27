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

  params :paginator do
    optional :page, type: Integer, default: 1, desc: "Page number."
    optional :per_page, type: Integer, default: 10, desc: "Per page value."
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

end
