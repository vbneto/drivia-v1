class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def require_professor!
    unless current_user.is_professor?
      redirect_to root_path, :alert => :unauthenticated
    end
  end
  
  def current_parent
    session[:current_parent_id] = current_user.parent if current_user.is_parent?
  end
  
  def current_student
    session[:current_student_id] = current_user.student if current_user.is_student?
  end
  
  def current_professor
    session[:current_professor_id] = current_user.professor if current_user.is_professor?
  end
  
  def current_school_admin
    session[:current_school_admin_id] = current_user if current_user.is_school_admin?
  end
  
  def month_number month
    Date::MONTHNAMES.index(month) 
  end
  
end
