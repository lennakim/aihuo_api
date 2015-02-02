class Reports < Grape::API
  helpers do
    def reportable_params
      declared(params, include_missing: false)[:report]
    end
  end

  resources 'reports' do
    desc "Complete a task."
    params do
      requires :sign, type: String, desc: "Sign value"
      requires :report, type: Hash do
        requires :device_id, type: String, desc: "Device ID"
        requires :reportable_id, type: String, desc: "Report ID"
        requires :reportable_type, type: String, values: ["Topic", "Reply"], desc: "Report Type"
        requires :reason, type: String, desc: "Report Reason"
      end
    end
    post "/", jbuilder: 'reports/report' do
      verify_sign
      @report = Report.create(reportable_params)
    end
  end
end
