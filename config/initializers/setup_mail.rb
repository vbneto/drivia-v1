=begin
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.mandrillapp.com",
  :port                 => 587,
  :domain               => "asciicasts.com",
  :user_name            => "pawan.sahu27@gmail.com",
  :password             => "MvTCXOI25KDalxaopVXAGg",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options[:host] = "localhost:3000"
