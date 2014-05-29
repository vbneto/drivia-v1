class ProfessorsController < ApplicationController
  autocomplete :subject, :name, :full => true
  autocomplete :grade_name, :name
  autocomplete :school_grade, :grade_class
  before_filter :authenticate_user!
  before_filter :require_professor!, except: ['new_professor_record', 'register_new_professor_record', 'autocomplete_subject_name', 'autocomplete_grade_name_name', 'autocomplete_school_grade_grade_class']
  before_filter :require_school_administration!, only: ['new_professor_record', 'register_new_professor_record', 'autocomplete_subject_name', 'autocomplete_grade_name_name', 'autocomplete_school_grade_grade_class']
  
  def index
    @professor_grades = current_professor.professor_grades
  end
  
  def show_students
    @school = current_professor.professor_record.schools.find(params["school_id"])
    @subject = params[:subject]
    @grade_name = params[:grade_name]
    @grade_class = params[:grade_class]
    @students = @school.select_student_of_current_grade(@grade_name, @grade_class).sort_by(&:student_name)
    @bimester = params[:bimester].present? ? params[:bimester] : bimester(1)
    respond_to do |format|
      format.html
      format.xls
    end
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
    students_status_id = StudentStatus.where("school_id=? and current_grade=? ", current_grade[:school_id], current_grade[:grade]).map(&:id)
    
    all_student_grades = MonthlyGrade.select{|grade| students_status_id.include?(grade.student_status_id)}
    all_student_grades.select{|grade| grade.subject_name == params[:subject]}
  end
  
end
