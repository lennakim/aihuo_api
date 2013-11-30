module API
  class Replies < Grape::API
    resources 'replies' do
      desc "Destroy a reply."
      params do
        requires :id, type: String, desc: "Reply ID."
      end
      delete ':id', jbuilder: 'replies/reply' do
        @reply = Reply.find(params[:id])
        if @reply.can_destroy_by?(params[:device_id])
          @reply.destroy
          status 202
        else
          error! "Access Denied", 401
        end
      end
    end
  end
end

