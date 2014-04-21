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
      group :member, type: Hash do
        requires :nickname, type: String, desc: "Member nickname"
        optional :avatar, type: String, desc: "Member avatar url"
        requires :gender, type: Integer, values: [0, 1], default: 0, desc: "Member gender"
      end
    end

    post "/", jbuilder: 'members/member' do
      if sign_approval?
        @member = Member.new(member_params)
        error!(@member.errors.full_messages.join, 500) unless @member.save
      else
        error! "Access Denied", 401
      end
    end

    params do
      requires :id, type: String, desc: "Member id."
    end
    route_param :id do
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
        requires :captcha, type: String, desc: "Member phone"
        requires :phone, type: String, desc: "Member password"
      end

      put :validate_captcha, jbuilder: 'members/member' do
        if sign_approval?
          @member = Member.find(params[:id])
          if @member.validate_captcha?(params[:phone], params[:captcha])
            @member.relate_to_device(params[:device_id])
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
        end
      end

      put "/", jbuilder: 'members/member' do
        @member = Member.find(params[:id])
        if sign_approval? && @member.authenticate?(params[:password])
          @member.update_attributes(member_params)
        else
          error! "Access Denied", 401
        end
      end
    end

  end
end
