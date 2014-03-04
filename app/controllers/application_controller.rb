class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_in_path_for(resource)
    resource.is_a?(AdminUser) ? admin_dashboard_path : users_path
  end
  
end
