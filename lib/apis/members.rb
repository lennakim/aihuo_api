class Members < Grape::API
  helpers do
    def member_params
      declared(params, include_missing: false)[:member]
    end
  end

  resources 'members' do

    desc "Create a member."
    params do
      requires :sign, type: String, desc: "Sign value"
      requires :device_id, type: String, desc: "Device ID"
      group :member, type: Hash do
        requires :nickname, type: String, desc: "Member nickname"
        requires :password, type: String, desc: "Member password"
        optional :avatar, type: String, desc: "Member avatar url"
        requires :gender, type: Integer, values: [0, 1], default: 0, desc: "Member gender"
      end
    end

    post "/", jbuilder: 'members/member' do
      if sign_approval?
        @member = Member.new(member_params)
        if @member.save
          @member.relate_to_device(params[:device_id])
        else
          error!(@member.errors.full_messages.join, 500)
        end
      else
        error! "Access Denied", 401
      end
    end

    params do
      requires :id, type: String, desc: "Member id."
    end
    route_param :id do
      desc "Get member detail"
      get "/", jbuilder: 'members/member' do
        @member = Member.find(params[:id])
      end

      desc "Send captcha"
      params do
        requires :sign, type: String, desc: "Sign value"
        requires :phone, type: String
      end

      put :send_captcha, jbuilder: 'members/member' do
        if sign_approval?
          @member = Member.find(params[:id])
          @member.update_attribute(:phone, params[:phone])
          @member.send_captcha
        else
          error! "Access Denied", 401
        end
      end

      desc "Validate captcha"
      params do
        requires :device_id, type: String, desc: "Device ID"
        requires :sign, type: String, desc: "Sign value"
        requires :captcha, type: String, desc: "Member captcha"
        requires :phone, type: String, desc: "Member phone"
      end

      put :validate_captcha, jbuilder: 'members/member' do
        if sign_approval?
          @member = Member.find(params[:id])
          if @member.validate_captcha?(params[:phone], params[:captcha])
            @member.relate_to_device(params[:device_id])
            @member.verified!
          end
        else
          error! "Access Denied", 401
        end
      end

      desc "Update member attribute"
      params do
        requires :sign, type: String, desc: "Sign value"
        requires :password, type: String, desc: "Member password"
        group :member, type: Hash do
          requires :nickname, type: String, desc: "Member nickname"
          requires :gender, type: Integer, values: [0, 1], default: 0, desc: "Member gender"
          optional :avatar, type: String, desc: "Member avatar url"
          optional :receive_message_notification, type: Integer, values: [0, 1], default: 1, desc: "Member receive notification"
          optional :receive_reply_notification, type: Integer, values: [0, 1], default: 1, desc: "Member receive notification"
        end
      end

      put "/", jbuilder: 'members/member' do
        @member = Member.find(params[:id])
        if sign_approval? && @member.authenticate?(params[:password])
          unless @member.update_attributes(member_params)
            error!(@member.errors.full_messages.join, 500)
          end
        else
          error! "Access Denied", 401
        end
      end
    end

  end
end