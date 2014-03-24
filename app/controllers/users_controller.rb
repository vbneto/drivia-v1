class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_cpf, :create_registration_with_cpf, :signup]
  
  def home
  end
  
  def index
    if !current_user.is_professor?
      if current_user.is_parent?
        @students = Parent.find_student_by_parent_id current_user.id
        @grades = @students.first.monthly_grades
        subjects = MonthlyGrade.uniq_grade @grades
        @subject_average = subject_average(subjects, @grades)
      end  
      if current_user.is_student?
        @student = Student.find_student_by_student_id current_user.id
        @grades = @student.monthly_grades
        subjects = MonthlyGrade.uniq_grade @grades
        @subject_average = subject_average(subjects, @grades)
      end
      all_months = @grades.map(&:month).uniq
      @month_average = all_months_average(all_months, @grades).to_a.insert(0,["Months","Grade"]) 
      @average = calculate_average @grades
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
    unless params[:sub]=='null'
      @subjects = params[:sub].split(",")
      @subjects = 'all' if @subjects.first=="select_all" 
      student = StudentFromExcel.find_by_id(params[:stid]) if current_user.is_parent?
      student = Student.find_by_user_id(current_user.id).student_from_excel if current_user.is_student?
      @grades = student.monthly_grades 
      if @subjects == 'all'
        subjects = MonthlyGrade.uniq_grade @grades
        @subject_average = subject_average(subjects, @grades)
        @average = calculate_average @grades
        all_months = @grades.map(&:month).uniq
        @month_average = all_months_average(all_months, @grades).to_a.insert(0,["Months","Grade"])
      else
        @subject_average = subject_average(@subjects, @grades)
        @subjects = @grades.select{|grade| @subjects.include?(grade.subject_name)}
        @average = calculate_average @subjects
        all_months = @subjects.map(&:month).uniq
        @month_average = all_months_average(all_months, @subjects).to_a.insert(0,["Months","Grade"])
      end  
    end  
  end
  
  def change_student
    @student = StudentFromExcel.find_by_id(params[:id])
    @grades = @student.monthly_grades
    subjects = MonthlyGrade.uniq_grade @grades
    @subject_average = subject_average(subjects, @grades)
    @average = calculate_average @grades
    all_months = @grades.map(&:month).uniq
    @month_average = all_months_average(all_months, @grades).to_a.insert(0,["Months","Grade"])
  end
  
  def calculate_average grades
    average = 0
    grades.each{|grade| average = average + grade.grade}
    average = (average/grades.size).round(2)  if average > 0
    average
  end
   
  def new_registration_with_cpf
    @role = params[:role]
  end
  
  def subject_average(subjects, grades)
    subject_average = {}
    subjects.each do |subject|
      perticular_subject = MonthlyGrade.particular_subject(grades, subject)
      subject_average.merge!({subject => ((perticular_subject.map(&:grade).inject(:+))/perticular_subject.count).round(2)})
    end
    subject_average
  end
  
  def all_months_average(all_months, grades)
    month_average = {}
    all_months.each do |month|
      perticular_month = grades.select{|grade| grade.month == month}
      month_average.merge!({Date::MONTHNAMES[month] => ((perticular_month.map(&:grade).inject(:+))/perticular_month.count).round(2)})
    end
    month_average
  end
  
  def signup
  end
  
end
