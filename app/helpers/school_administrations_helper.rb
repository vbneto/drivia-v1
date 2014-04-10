module SchoolAdministrationsHelper
  
  def set_student_status student
    student.is_deactive_student? ? 'false' : 'true'
  end
  
  def is_student_first_access student
    student.student.present? ? 'true' : 'false'
  end
  
  def school_grades
    @all_students.map(&:current_grade).uniq.sort.insert(0,'All')
  end
  
  def show_status student
    student.is_active_student? ? 'Deactivate' : 'Activate'
  end
  
  def change_date_formate date
    date.strftime("%d/%m/%Y")
  end
  
end
