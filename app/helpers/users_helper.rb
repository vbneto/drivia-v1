module UsersHelper

  def set_end_year
    @student.monthly_grades.map(&:year).uniq.sort.last
  end
  
  def set_start_year
    @student.monthly_grades.map(&:year).uniq.sort.first
  end
  
  def set_selected_year
    @student_monthly_grades.first.year unless @student_monthly_grades.blank?
  end
  
  def monthly_grades_months
    @student.monthly_grades.map(&:month).uniq.sort.map{|m| Date::MONTHNAMES[m]}
  end
  
  def select_default_start_month
    params[:start_month].blank? ? monthly_grades_months.first : params[:start_month]
  end
  
  def select_default_end_month
    params[:end_month].blank? ? monthly_grades_months.last : params[:end_month]
  end
  
  def student_options_for_parent
    @parent_students.reject{|student| student.is_deactive_student?}.map{|student| [student.student_name, student.id]}
  end
  
  
end
