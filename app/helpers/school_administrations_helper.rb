module SchoolAdministrationsHelper
  
  def set_student_status student
    (student.is_deactive_student_for_school? current_school_administration.school) ? 'false' : 'true'
  end
  
  def set_professor_status professor
    (professor.status == User.student_active) ? true : false
  end
  
  def set_parent_status parent
    parent.is_deactive_parent? ? 'false' : 'true'
  end
  
  def is_student_first_access student
    student.student.present? ? true : false
  end
  
  def is_professor_first_access professor
    professor.professor_record.professor.present? ? true : false
  end
  
  def school_grades
    school_id = current_school_administration.school_id
    school_grades = @all_students.map do |student|
                      student = student.current_school_status school_id
                      student.current_grade + student.grade_class
                    end
    school_grades.uniq.sort.insert(0,'All')     

  end
  
  def show_student_status student
    student.is_active_student? ? 'Deactivate' : 'Activate'
  end
  
  def show_professor_status professor
    (set_professor_status professor) ? 'Deactivate' : 'Activate'
  end
  
  def show_parent_status parent
    parent.is_active_parent? ? 'Deactivate' : 'Activate'
  end
  
  def change_date_formate date
    date.strftime("%d/%m/%Y") unless date.blank?
  end
  
  def number_of_students (parents)
    count = parents.includes(:student_from_excels).map!{|parent| parent.student_from_excels.count}.uniq
    initial = ['All',['No students','0']]
    initial.concat(count.compact)
  end
  
  def number_of_parents (students)
    count = students.includes(:parents).map!{|student| student.parents.count unless student.parents.blank? }.uniq
    initial = ['All',['No parents','0']]
    initial.concat(count.compact)
  end
  
  def count_parents (student)
    student.parents.blank? ? "No parents" : student.parents.count 
  end
  
  def student_current_grade student
    student_status = student.student_statuses.first
    student_status.current_grade + student_status.grade_class
  end
  
  def student_parents_count student
    parent_count =  student.parents.blank? ? nil : student.parents.count
    parent_count.blank? ? "no parent" : parent_count
  end
  
  def professor_current_grade professor
    professor.grade_name.name+ " " + professor.grade_class
  end
  
  def student_current_grade_for_school student
    student.student_statuses.where(school_id: current_school_administration.school_id).first.current_grade
  end
  
  def student_of_current_school_for_parent parent
    parent.student_from_excels.select{|student| student.student_statuses.map(&:school_id).include?current_school_administration.school_id} if parent
  end
  
  def professor_email professor
    professor = professor.professor_record.professor if professor.professor_record
    professor.user.email if professor
  end
  
  def professor_phoneprefix professor
    professor = professor.professor_record.professor if professor.professor_record
    professor.user.phoneprefix if professor
  end
  
  def professor_phone professor
    professor = professor.professor_record.professor if professor.professor_record
    professor.user.phone if professor
  end
    
end
