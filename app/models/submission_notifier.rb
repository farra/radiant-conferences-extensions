class SubmissionNotifier < ActionMailer::Base
  include ActionController::UrlWriter
  
  def notification(options={})
    @from = "notification@apachecon.com"
    @to = options[:to]
    @body = options
  end
end