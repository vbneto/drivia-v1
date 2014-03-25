class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_cpf, :create_registration_with_cpf, :signup]
  
  def home
  end
  
  def index
    
    if !current_user.is_professor?
      if current_user.is_parent?
        @students = Parent.find_student_by_parent_id current_user.id
        @student = @students.first 
      elsif current_user.is_student?
        @student = Student.find_student_by_student_id current_user.id
      end
      @grades = @student.monthly_grades
      subjects = MonthlyGrade.uniq_grade @grades
      @subject_average = subject_average(subjects, @grades)
      
      all_months = @grades.map(&:month).uniq
      @month_average = Student.all_months_average(all_months, @grades).to_a.insert(0,["Months","Grade"]) 
      
      @all_student_id_of_current_grade = StudentFromExcel.find_all_student_id_of_current_grade @student
      all_student_grades = MonthlyGrade.select{|grade| @all_student_id_of_current_grade.include?(grade.student_from_excel_id)}
      @all_student_month_average = Student.all_months_average(all_months, all_student_grades).to_a.insert(0,["Months","Grade"]) 
      
      @overall_average = calculate_overall_average @grades
    else
      @grades = GradeFromExcel.where(:professor_email => current_user.email)   
    end  
  end
  
  def create_registration_with_cpf
    @role = params[:user]
    if @role != 'professor'
      @cpf = User.check_cpf params[:cpf]
      @student = StudentFromExcel.find_by_cpf(@cpf) 
      if @student.nil?
        flash[:error]= "student with given cpf was not found"
        redirect_to new_registration_with_cpf_users_path(role: @role) and return
      elsif @role == 'student' && !Student.find_by_student_from_excel_id(@student.id.to_s).nil?
        flash[:error]= "student was already signup with this cpf #{@cpf}"
        redirect_to new_registration_with_cpf_users_path(role: @role) and return
      elsif @role == 'parent' && @student.student_parents.size == 2
        flash[:error]= "There are already two parents signup with this cpf #{@cpf}"
        redirect_to new_registration_with_cpf_users_path(role: @role) and return
      end  
    else
      @email = params[:email]
      @professor = GradeFromExcel.find_by_professor_email(@email)
      if @professor.nil?
        flash[:error]= "Professor with given email was not found"
        redirect_to new_registration_with_cpf_users_path(role: @role) and return
      elsif User.find_by_email(@email).present?
        flash[:error]= "Professor with given email was already present"
        redirect_to new_registration_with_cpf_users_path(role: @role) and return
      end
    end
    render ask_question_users_path  
  end
  
  def change_subjects
    unless params[:sub] == 'null'
      @subjects = params[:sub].split(",")
      student = StudentFromExcel.find_by_id(params[:stid]) if current_user.is_parent?
      student = Student.find_by_user_id(current_user.id).student_from_excel if current_user.is_student?
      grades = student.monthly_grades 
      all_student_id_of_current_grade = StudentFromExcel.find_all_student_id_of_current_grade student
      all_student_grades = MonthlyGrade.select{|grade| all_student_id_of_current_grade.include?(grade.student_from_excel_id)}
      if @subjects.first == 'select_all'
        subjects = MonthlyGrade.uniq_grade grades
        @subject_average = subject_average(subjects, grades)
      else
        @subject_average = subject_average(@subjects, grades)
        grades = grades.select{|grade| @subjects.include?(grade.subject_name)}
        all_student_grades = all_student_grades.select{|grade| @subjects.include?(grade.subject_name)}
      end
      @overall_average = calculate_overall_average grades
      all_months = grades.map(&:month).uniq
      @month_average = Student.all_months_average(all_months, grades).to_a.insert(0,["Months","Grade"])
      @all_student_month_average = Student.all_months_average(all_months, all_student_grades).to_a.insert(0,["Months","Grade"])  
    end  
  end
  
  def change_student
    @student = StudentFromExcel.find_by_id(params[:id])
    @grades = @student.monthly_grades
    subjects = MonthlyGrade.uniq_grade @grades
    @subject_average = subject_average(subjects, @grades)
    @overall_average = calculate_overall_average @grades
    all_months = @grades.map(&:month).uniq
    @month_average = Student.all_months_average(all_months, @grades).to_a.insert(0,["Months","Grade"])
    all_student_id_of_current_grade = StudentFromExcel.find_all_student_id_of_current_grade @student
    all_student_grades = MonthlyGrade.select{|grade| all_student_id_of_current_grade.include?(grade.student_from_excel_id)}
    @all_student_month_average = Student.all_months_average(all_months, all_student_grades).to_a.insert(0,["Months","Grade"])
  end
  
  def calculate_overall_average grades
    average = 0
    grades.each{|grade| average = average + grade.grade}
    average = (average/grades.size).round(2)  if average > 0
    average
  end
   
  def subject_average(subjects, grades)
    subject_average = {}
    subjects.each do |subject|
      perticular_subject = MonthlyGrade.particular_subject(grades, subject)
      subject_average.merge!({subject => ((perticular_subject.map(&:grade).inject(:+))/perticular_subject.count).round(2)})
    end
    subject_average
  end
  
  def new_registration_with_cpf
    @role = params[:role]
  end
  
  def signup
  end
  
end
