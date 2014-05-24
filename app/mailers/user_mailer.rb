class UserMailer < ActionMailer::Base
  def send_mail_to_user user
    @student = user.student.student_from_excel
    mail(:to => user.email, :subject => "your signup code", :from => "pawan@grepruby.com")
  end
end
