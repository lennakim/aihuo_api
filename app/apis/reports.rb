class Reports < Grape::API
  helpers do
    def decrypt_reportable_id(reportable_id, reportable_type)
      begin
        reportable_class = reportable_type.constantize
        reportable_class.decrypt(reportable_class.encrypted_id_key, reportable_id)
      rescue OpenSSL::Cipher::CipherError => e
        error!({ error: 'Unknown Reportable ID' }, 500)
      end
    end

    def reportable_params
      reportable_id = decrypt_reportable_id(
        params[:report][:reportable_id],
        params[:report][:reportable_type]
      )
      params[:report][:reportable_id] = reportable_id
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
      @report = Report.new(reportable_params) unless @report
    end
  end
end
