module SchoolsHelper

  def uniq_school_grade_name
    current_school_administration.grade_names.map(&:name).uniq.sort
  end
  
  def uniq_school_grade_class
    currunt_grade_id = GradeName.find_by_name(@student_record.get_active_status.current_grade).id
    current_school_administration.school_grades.where(grade_name_id: currunt_grade_id).map(&:grade_class).uniq.sort
  end
  
  def school_grade_classes(grade_names)
    current_school_administration.school_grades.where("grade_name_id = ?",grade_names.first[1]).map{|grade| grade.grade_class}.uniq
  end
end
