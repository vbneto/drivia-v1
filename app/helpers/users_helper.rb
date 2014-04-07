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
    if params[:date].blank? 
      @student.monthly_grades.select{|grade| grade.year == set_end_year}.map(&:month).uniq.sort.map{|m| Date::MONTHNAMES[m]}
    else
      @student.monthly_grades.select{|grade| grade.year == params[:date][:year].to_i}.map(&:month).uniq.sort.map{|m| Date::MONTHNAMES[m]}
    end 
  end
  
  def select_default_start_month
    if params[:start_month].blank?
      monthly_grades_months.first
    else
      monthly_grades_months.select{|month| month == params[:start_month]}.blank? ? monthly_grades_months.first : params[:start_month] 
    end  
  end
  
  def select_default_end_month
    if params[:end_month].blank?
      monthly_grades_months.last
    else
      monthly_grades_months.select{|month| month == params[:end_month]}.blank? ? monthly_grades_months.last : params[:end_month] 
    end  
  end
  
  def student_options_for_parent
    @parent_students.reject{|student| student.is_deactive_student?}.map{|student| [student.student_name, student.id]}
  end
  
  
end
