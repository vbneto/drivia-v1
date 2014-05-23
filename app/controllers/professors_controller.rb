class ProfessorsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_professor!
  
  def index
    @professor_grades = current_professor.professor_grades
  end
  
  def show_students
    @school = School.find(params[:school_id])
    @subject = params[:subject]
    @grade_name = params[:grade_name]
    @grade_class = params[:grade_class]
    
    @students = @school.student_from_excels
    @students.select!{|student| student.student_statuses.where('school_id=? and status=? and current_grade=? and grade_class=?', params[:school_id], User.student_active, @grade_name, @grade_class).first}
    @bimester = params[:bimester].present? ? params[:bimester] : bimester(1)
  end  
  
  def show_student_graph
    all_student_grade_with_subject = student_of_current_grade_and_subject params
    @all_student_month_average = Grade.initialize_month_graph(all_student_grade_with_subject, current_user)
  end
  
  private
  
  def student_of_current_grade_and_subject current_grade
    students_status_id = StudentStatus.where("school_id=? and current_grade=? ", current_grade[:school_id], current_grade[:grade]).map(&:id)
    
    all_student_grades = MonthlyGrade.select{|grade| students_status_id.include?(grade.student_status_id)}
    all_student_grades.select{|grade| grade.subject_name == params[:subject]}
  end
  
end
