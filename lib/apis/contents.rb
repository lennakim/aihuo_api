class Contents < Grape::API
  helpers do
  end

  resources 'contents' do

    desc "Listing contents."
    params do
      optional :page, type: Integer, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get "/", jbuilder: 'contents/contents' do
      cache(key: [:v2, :contents, params[:page], params[:per_page]], expires_in: 4.hours) do
        @contents = paginate(Content)
      end
    end



    params do
      requires :id, type: String, desc: "Content id."
    end
    route_param :id do

      before do
        @content = Content.find(params[:id])
      end

      desc "Return a content."
      get "/", jbuilder: 'contents/content'  do
        cache(key: [:v2, :content, @content], expires_in: 1.days) do
          @content
        end
      end

      desc "Like a content."
      put :like, jbuilder: 'contents/content' do
        @content.liked
        status 202
      end

      desc "Repost a content"
      put :forward, jbuilder: 'contents/content' do
        @content.forward
        status 202
      end
    end


  end
end
