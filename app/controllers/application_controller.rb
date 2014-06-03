class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :export_i18n_messages
  helper_method :bimester,:current_parent, :current_professor, :current_school_administration, :current_student
  
  def export_i18n_messages
    SimplesIdeias::I18n.export! if Rails.env.development?
  end
  
  def require_professor!
    unless current_professor
      flash[:error] = "you need to signin as professor before continue"
      redirect_to root_path 
    end
  end
  
  def require_school_administration!
    unless current_school_administration
      flash[:error] = "you need to signin as school administrator before continue"
      redirect_to root_path 
    end
  end
  
  def after_sign_in_path_for(resource)
    if current_admin_user
      admin_dashboard_path
    elsif current_school_administration
      school_administrations_path
    elsif current_professor
      professors_path
    elsif current_student or current_parent
      users_path       
    end
  end
  
  def current_parent
    current_user.parent if current_user.is_parent?
  end
  
  def current_student
    current_user.student if current_user.is_student?
  end
  
  def current_professor
    current_user.professor if current_user.is_professor?
  end
  
  def current_school_administration
    current_user.school_administration if current_user.is_school_administration?
  end
  
  def month_number month
    Date::MONTHNAMES.index(month) 
  end
  
  define_method("bimester") do |argument|
    BIMESTER[argument-1]
  end

end
