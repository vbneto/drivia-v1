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
      (monthly_grades_bimesters.include?params[:start_month]) ? params[:start_month] : monthly_grades_bimesters.first
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
  
  def set_month_average_to_graph
    raw @month_average
  end
  
  def set_average_particular_student_to_graph
    average = @average_particular_student_of_current_grade
    unless average.blank?
      if current_parent or current_school_administration
        average.insert(0,['student',@student.student_name, 'coleagues']) 
      elsif current_student
        average.insert(0,['student','You', 'Coleagues']) 
      end
      @subject_average.size == 1 ? average[0][3] = 'Class average' : average[0][3] = 'Class overall average'
      raw average.to_json
    end  
  end
  
end
