module UsersHelper

  def set_end_year
    @student_monthly_grades.map(&:year).uniq.sort.last unless @student_monthly_grades.blank?
  end
  
  def set_start_year
    @student_monthly_grades.map(&:year).uniq.sort.first unless @student_monthly_grades.blank?
  end
  
  def set_selected_year
    @student_monthly_grades.first.year unless @student_monthly_grades.blank?
  end
  
  def monthly_grades_months
    unless @student_monthly_grades.blank?
      if params[:date].blank? || true
        @student_school_status.monthly_grades.select{|grade| grade.year == set_end_year}.map(&:month).uniq.sort.map{|m| Date::MONTHNAMES[m]}
      else
        @student.student_statuses.first.monthly_grades.select{|grade| grade.year == params[:date][:year].to_i}.map(&:month).uniq.sort.map{|m| Date::MONTHNAMES[m]}
      end
    else
      Date::MONTHNAMES[Date.today.month].split
    end  
  end
  
  def monthly_grades_bimesters
    unless @student_monthly_grades.blank?
      @student_school_status.monthly_grades.select{|grade| grade.year == set_end_year}.map(&:bimester).uniq.sort.map{|b| b}
    else
      bimester(1).split
    end  
  end
  
  def select_default_start_bimester
    if params[:start_month].blank?
      monthly_grades_bimesters.first
    else
      (monthly_grades_bimesters.include?params[:start_month]) ? params[:start_month] : monthly_grades_months.first
    end  
  end
  
  def select_default_end_bimester
    if params[:end_month].blank?
      monthly_grades_bimesters.last
    else
      (monthly_grades_bimesters.include?params[:end_month]) ? params[:end_month] : monthly_grades_bimesters.last
    end  
  end
  
  def student_options_for_parent
    @parent_students.map{|student| [student.student_name, student.id]}
  end
  
  def school_options_for_parent
    school = []
    @student.student_statuses.each{|status| school << [status.school.name, status.id] }
    school
  end

end
