module API
  class Topics < Grape::API

    resources 'topics' do
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
    end

  end
end
