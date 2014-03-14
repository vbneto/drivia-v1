class SchoolsController < ApplicationController
  
  def new
    @school = School.new 
  end
  
  def create
    @school = School.new(params[:school])
    @school.save ? flash[:notice]="school save" : flash[:partial]="please fill form correctly"
    redirect_to admins_path
  end
  
  def index
    @schools = School.all
  end
  
  def import_students_list
    already_present_students = StudentFromExcel.student_list(params[:file],params[:school_id])
    notice = "List of students imported."
    if already_present_students.size > 0
      notice = "This are the CPF which is either already present or invalid </br>"+ already_present_students.join(", ")
    end
    redirect_to add_student_list_admins_path, notice: notice
  end
  
  def import_grade_list
    already_present_grades = GradeFromExcel.grade_list(params[:file],params[:school_id])
    notice = "List of grades imported."
    if already_present_grades.size > 0
      notice = "This are the grades which is already present </br>"+ already_present_grades.join(", ")
    end
    redirect_to add_grade_list_admins_path, notice: notice
  end
  
end
