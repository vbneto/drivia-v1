class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_cpf, :create_registration_with_cpf]
  
  def home
  end
  
  def index
    if current_user.is_parent?
      @students = Parent.find_by_user_id(current_user.id).student_from_excels
      @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", @students.first.current_grade, @students.first.school_id)
    end  
    
    if current_user.is_student?
      @student = Student.find_by_user_id(User.find_by_id(current_user.id)).student_from_excel
      @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", @student.current_grade, @student.school_id)
    end
    @average = calculate_average @grades
  end
  
  def create_registration_with_cpf
    cpf = params[:cpf]
    @student = StudentFromExcel.find_by_cpf(cpf.to_s)
    if @student.nil?
      redirect_to new_registration_with_cpf_users_path, :notice => "student not found"
    else
      render parent_or_student_users_path,:notice => "Please enter more details"
    end  
  end
  
  def change_student
    @student = StudentFromExcel.find_by_id(params[:id])
    @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", @student.current_grade, @student.school_id)
    @average = calculate_average @grades
  end
  
  def change_subjects
    @subjects = params[:sub].split(",")
    @subjects = 'all' if @subjects.first=="select_all" 
    student = StudentFromExcel.find_by_id(params[:stid]) if current_user.is_parent?
    student = Student.find_by_user_id(current_user.id).student_from_excel if current_user.is_student?
    @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", student.current_grade, student.school_id)
    @subjects = @grades.select{|grade| @subjects.include?(grade.subject_name)} if @subjects!="all" 
    if @subjects == 'all'
      @average = calculate_average @grades
    else
      @average = calculate_average @subjects
    end  
  end
  
  def calculate_average grades
    average = 0
    grades.each{|grade| average = average + grade.subject_average}
    average = (average/grades.size).round(2)  if average > 0
  end
  
end
