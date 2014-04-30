class ProfessorsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_professor!, except: ['new_professor_record', 'register_new_professor_record']
  before_filter :require_school_administration!, only: ['new_professor_record', 'register_new_professor_record']
  
  def index
    @professor_grades = current_user.professor_grades
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
  
  def new_professor_record
    @professor_record = ProfessorRecord.new
    @professor_record.school_grades.build
  end
  
  def register_new_professor_record
    invalid_grades = ProfessorRecord.create_professor_record(params, current_school_administration.school_id)
    if invalid_grades.blank?
      flash[:notice] = "All grades of professor added successfully"
      redirect_to show_users_school_administrations_path
    else
      flash[:error] = "This are the grades which are already theach by any professors: "+invalid_grades.join(', ')
      flash[:notice] = "All other grades of professor added successfully"
      redirect_to new_professor_record_professors_path
    end  
  end
  
  private
  
  def student_of_current_grade_and_subject current_grade
    all_student_id = StudentFromExcel.includes(:student_statuses).where(student_statuses: { school_id: current_grade[:school_id], current_grade: current_grade[:grade] }).map(&:id)
    all_student_grades = MonthlyGrade.select{|grade| all_student_id.include?(grade.student_from_excel_id)}
    all_student_grades.select{|grade| grade.subject_name == params[:subject]}
  end
  
end
