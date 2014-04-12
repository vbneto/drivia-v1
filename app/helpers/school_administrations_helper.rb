module SchoolAdministrationsHelper
  
  def set_student_status student
    student.is_deactive_student? ? 'false' : 'true'
  end
  
  def set_parent_status parent
    parent.is_deactive_parent? ? 'false' : 'true'
  end
  
  def is_student_first_access student
    student.student.present? ? 'true' : 'false'
  end
  
  def school_grades
    @all_students.map(&:current_grade).uniq.sort.insert(0,'All')
  end
  
  def show_student_status student
    student.is_active_student? ? 'Deactivate' : 'Activate'
  end
  
  def show_parent_status parent
    parent.is_active_parent? ? 'Deactivate' : 'Activate'
  end
  
  def change_date_formate date
    date.strftime("%d/%m/%Y")
  end
  
  def number_of_students (parents)
    count = parents.includes(:student_from_excels).map!{|parent| parent.student_from_excels.count}.uniq
    initial = ['All',['No students','0']]
    initial.concat(count)
  end
  
  def number_of_parents (students)
    count = students.includes(:parents).map!{|student| student.parents.count unless student.parents.blank?}.uniq
    initial = ['All',['No parents','0']]
    initial.concat(count)
  end
  
  def count_parents (student)
    student.parents.blank? ? "No parents" : student.parents.count 
  end
  
end
