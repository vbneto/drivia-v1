module ApplicationHelper

  def school_administration_for_student_dashboard
    "Loged is as School Administration" if controller.controller_name == 'users' and controller.action_name == 'index' 
  end
  
end
