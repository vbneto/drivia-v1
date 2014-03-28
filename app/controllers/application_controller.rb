class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def require_professor!
    unless current_user.is_professor?
      redirect_to root_path, :alert => :unauthenticated
    end
  end
  
end
