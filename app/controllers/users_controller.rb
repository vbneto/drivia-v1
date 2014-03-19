class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_cpf, :create_registration_with_cpf, :signup]
  
  def home
  end
  
  def index
    if !current_user.is_professor?
      if current_user.is_parent?
        @students = Parent.find_by_user_id(current_user.id).student_from_excels
        @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", @students.first.current_grade, @students.first.school_id)
      end  
      
      if current_user.is_student?
        @student = Student.find_by_user_id(User.find_by_id(current_user.id)).student_from_excel
        @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", @student.current_grade, @student.school_id)
      end
      @average = calculate_average @grades
    else
      @grades = GradeFromExcel.where(:professor_email => current_user.email)   
    end  
  end
  
  def create_registration_with_cpf
    @role = params[:user]
    if @role != 'professor'
      @cpf = params[:cpf]
      if @cpf.size == 11
        @cpf.insert(3,'.')
        @cpf.insert(7,'.')
        @cpf.insert(11,'-')
      end
      @student = StudentFromExcel.find_by_cpf(@cpf) 
      if @student.nil?
        flash[:error]= "student with given cpf was not found"
        redirect_to new_registration_with_cpf_users_path(role:@role)
        return
      elsif @role == 'student' && !Student.find_by_student_from_excel_id(@student.id.to_s).nil?
        flash[:error]= "student was already signup with this cpf #{@cpf}"
        redirect_to new_registration_with_cpf_users_path(role:@role)
        return 
      elsif @role == 'parent' && @student.student_parents.size == 2
        flash[:error]= "There are already two parents signup with this cpf #{@cpf}"
        redirect_to new_registration_with_cpf_users_path(role:@role)
        return
      end  
    else
      @email = params[:email]
      @professor = GradeFromExcel.find_by_professor_email(@email)
      if @professor.nil?
        flash[:error]= "Professor with given email was not found"
        redirect_to new_registration_with_cpf_users_path(role:@role)
        return
      elsif User.find_by_email(@email).present?
        flash[:error]= "Professor with given email was already present"
        redirect_to new_registration_with_cpf_users_path(role:@role)
        return  
      end
    end
    render ask_question_users_path  
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
   
  def new_registration_with_cpf
    @role = params[:role]
  end
  
  def signup
  end
  
end
