class Tasks < Grape::API
  helpers do
    def member_id
      Member.decrypt(Member.encrypted_id_key, params[:member_id])
    end
  end

  resources 'tasks' do
    desc "Complete a task."
    params do
      requires :sign, type: String, desc: "Sign value"
      requires :action, type: Symbol, values: [:login], default: :login, desc: "Filtering action."
      requires :member_id, type: String, desc: "Member ID."
      requires :password, type: String, desc: "Member Password."
    end
    post :complete, jbuilder: 'tasks/task' do
      if sign_approval? && authenticate?
        missions = Task.where(name: params[:action])
        missions.each do |mission|
          @task = TaskLogging.new(task_id: mission.id, member_id: member_id)
          error!(@task.errors[:task_id][0], 500) unless @task.save
        end
      else
        error! "Access Denied", 401
      end
    end
  end
end
