class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_in_path_for(resource)
    current_user.role == "admin" ? admins_path : users_path
    #resource.is_a?(AdminUser) ? admin_path : users_path
  end

end
