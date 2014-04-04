class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_cpf, :create_registration_with_cpf, :signup]
  
  
  def home
  end
  
  def index
    if current_parent
      @parent_students = current_parent.student_from_excels
      @student = @parent_students.first
    end
    @student = current_student.student_from_excel if current_student
    
    @student = StudentFromExcel.find_by_id(params[:student_id]) if current_school_administration
    
    @student_monthly_grades = current_user.student_monthly_grades(@student)
    @subject_average = Student.subject_average @student_monthly_grades
    @total_no_show = Student.total_no_show @student_monthly_grades
    
    month_average_of_student = Grade.initialize_month_graph(Student.all_months_average(@student_monthly_grades))
    unless @student_monthly_grades.blank?
      all_students_grades = @student.find_fellow_students_monthly_grade(@student_monthly_grades.first.year)
      
      all_student_month_average = Grade.initialize_month_graph(Student.all_months_average(all_students_grades))
      
      @month_average = merge_graph(month_average_of_student,all_student_month_average)
      
      @overall_average = student_monthly_grade_overall_average @student_monthly_grades
      
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_students_grades), @student)
    end  
  
  end
  
  def create_registration_with_cpf
    @role = params[:user]
    if (@role == User.find_student_role || @role == User.find_parent_role)
      @cpf = User.check_cpf params[:cpf]
      @student = StudentFromExcel.find_by_cpf(@cpf)
      if @student.nil?
        flash[:error]= "student with given cpf was not found"
        redirect_to new_registration_with_cpf_users_path(role: @role) and return
      elsif @role == User.find_student_role && !@student.student.blank?
        flash[:error]= "student was already signup with this cpf #{@cpf}"
        redirect_to new_registration_with_cpf_users_path(role: @role) and return
      elsif @student.is_deactive_student?
        flash[:error]= "Sorry, this account has been deactivated, please contact to school administration." 
        redirect_to new_registration_with_cpf_users_path(role: @role) and return
      elsif @role == User.find_parent_role && @student.student_parents.size == 2
        flash[:error]= "There are already two parents signup with this cpf #{@cpf}"
        redirect_to new_registration_with_cpf_users_path(role: @role) and return
      end
    elsif @role == User.find_professor_role
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
    unless params[:subjects].blank?
      @subjects = params[:subjects]
      @student = StudentFromExcel.find_by_id(params[:student_id_of_select_subject]) if current_parent || current_school_administration
      @student = Student.find_by_user_id(current_user.id).student_from_excel if current_student
      
      year = params[:year]
      all_student_grades = nil
      if year.blank?
        @student_monthly_grades = current_user.student_monthly_grades(@student)
        all_student_grades = @student.find_fellow_students_monthly_grade(@student_monthly_grades.first.year)
      else  
        date_range = (params[:start].to_i..params[:end].to_i).to_a 
        @student_monthly_grades = @student.monthly_grades.where(month: params[:start]..params[:end]).where(year: year) 
        all_student_grades = @student.find_fellow_students_monthly_grade(year.to_i).select{|grade| date_range.include?grade.month}
      end  
       
      if @subjects.first == 'select_all'
        subjects = MonthlyGrade.uniq_grade @student_monthly_grades
        @total_no_show = Student.total_no_show @student_monthly_grades
        @subject_average = Student.subject_average(@student_monthly_grades)
      else
        @total_no_show = Student.total_no_show(@subjects, @student_monthly_grades)
        @subject_average = Student.subject_average(@subjects, @student_monthly_grades)
        @student_monthly_grades = @student_monthly_grades.select{|grade| @subjects.include?(grade.subject_name)}
        all_student_grades = all_student_grades.select{|grade| @subjects.include?(grade.subject_name)} 
      end
      
      @overall_average = student_monthly_grade_overall_average @student_monthly_grades
      
      @month_average = Grade.initialize_month_graph(Student.all_months_average(@student_monthly_grades))
      
      @all_student_month_average = Grade.initialize_month_graph(Student.all_months_average(all_student_grades))
      @month_average = merge_graph(@month_average,@all_student_month_average)
      
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_student_grades), @student)
    end  
  end
  
  def change_student
    @student = StudentFromExcel.find(params[:student_list])
    all_student_grades = nil
    year = params[:year]
    if year.blank? || (!@student.monthly_grades.map(&:year).include?year.to_i)
      @student_monthly_grades = current_user.student_monthly_grades(@student)
      all_student_grades = @student.find_fellow_students_monthly_grade(@student_monthly_grades.first.year) unless 
      @student_monthly_grades.blank?
    else
      range = (params[:start].to_i..params[:end].to_i).to_a
      @student_monthly_grades = @student.monthly_grades.where(month: params[:start]..params[:end]).where(year: year)
      all_student_grades = (@student.find_fellow_students_monthly_grade year.to_i).select{|grade| range.include?grade.month}
    end  
    @total_no_show = Student.total_no_show @student_monthly_grades
    @subject_average = Student.subject_average(@student_monthly_grades)
    unless @student_monthly_grades.blank?
      @overall_average = student_monthly_grade_overall_average @student_monthly_grades
      
      @month_average = Grade.initialize_month_graph(Student.all_months_average(@student_monthly_grades))
      
      @all_student_month_average = Grade.initialize_month_graph(Student.all_months_average(all_student_grades))
      
      @month_average = merge_graph(@month_average, @all_student_month_average)
      
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_student_grades), @student)
    end      
  end
  
  def change_date
    start_month = month_number(params[:start_month])
    end_month = month_number(params[:end_month])
    year = params[:date][:year]
    @student = StudentFromExcel.find(params[:student_id])
    @student_monthly_grades = @student.monthly_grades.where(month: start_month..end_month).where(year: year)
    unless @student_monthly_grades.blank?
      @total_no_show = Student.total_no_show @student_monthly_grades
      @subject_average = Student.subject_average(@student_monthly_grades)
      @overall_average = student_monthly_grade_overall_average @student_monthly_grades
      @month_average = Grade.initialize_month_graph(Student.all_months_average(@student_monthly_grades))
      range = (start_month..end_month).to_a
      all_student_grades = (@student.find_fellow_students_monthly_grade(@student_monthly_grades.first.year)).select{|grade| range.include?grade.month}
      
      @all_student_month_average = Grade.initialize_month_graph(Student.all_months_average(all_student_grades))
      
      @month_average = merge_graph(@month_average, @all_student_month_average)
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_student_grades), @student)
    end  
  end
  
  def new_registration_with_cpf
    @role = params[:role]
  end
  
  def signup
  end
  
  private
  
  def student_monthly_grade_overall_average grades
    average = 0
    grades.reject!{|grade| grade.grade.blank? }
    grades.each{|grade| average = average + grade.grade}
    average = (average/grades.size).round(2) if average > 0
    average
  end
  
  def merge_graph(month_average, all_student_month_average)
    month_average.each_with_index do |average, index| 
      next month_average[0].insert(2,"Class Average") if index == 0
      month_average[index].insert(2,all_student_month_average[index][1])
    end
  end
  
end
