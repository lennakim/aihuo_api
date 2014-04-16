class Members < Grape::API
  helpers do
    def current_device
      @device = Device.where(device_id: params[:device_id]).first_or_create!
    end

    def member_params
      declared(params, include_missing: false)[:member]
    end
  end

  resources 'members' do

    desc "Create a member."
    params do
      requires :device_id, type: String, desc: "Device ID"
      requires :sign, type: String, desc: "Sign value"
      group :member, type: Hash do
        requires :nickname, type: String, desc: "Member nickname"
        requires :avatar, type: String, desc: "Member avatar url"
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
        group :member, type: Hash do
          requires :phone, type: String
        end
      end

      put :send_captcha, jbuilder: 'members/member' do
        if sign_approval?
          @member = Member.find(params[:id])
          @member.update_attribute(:phone, params[:member][:phone])
          @member.send_captcha
        else
          error! "Access Denied", 401
        end
      end
    end

  end
end
