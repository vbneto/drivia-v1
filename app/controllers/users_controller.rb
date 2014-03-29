class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_cpf, :create_registration_with_cpf, :signup]
  
  def home
  end
  
  def index
    if current_professor
      @grades = current_user.get_student_grades 
      render :index and return
    elsif current_parent
      @students = current_user.find_students 
      @student = @students.first
    end
    @student = current_user.find_student if current_student
    
    student_grades = current_user.get_student_grades
    
    @subject_average = subject_average student_grades
    
    @total_no_show = total_no_show student_grades
    
    month_average_of_student = Grade.initialize_month_graph(Student.all_months_average(student_grades))
    all_students_grades = Grade.find_all_student_grade @student 
    all_student_month_average = Grade.initialize_month_graph(Student.all_months_average(all_students_grades))
    
    @month_average = merge_graph(month_average_of_student,all_student_month_average)
    
    @overall_average = calculate_overall_average student_grades
    
    @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_students_grades), @student)
    
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
    unless params[:subjects].blank?
      @subjects = params[:subjects]
      
      @student = StudentFromExcel.find_by_id(params[:student_id_of_select_subject]) if current_user.is_parent?
      @student = Student.find_by_user_id(current_user.id).student_from_excel if current_user.is_student?
      
      grades = params[:year].blank? ? @student.monthly_grades : (@student.monthly_grades.where(month: date_range[:start]..date_range[:end]).where(year: date_range[:year])) 
      range = (params[:start].to_i..params[:end].to_i).to_a unless params[:year].blank?
      
      all_student_grades = params[:year].blank? ? (Grade.find_all_student_grade @student) : (Grade.find_all_student_grade @student).select{|grade| range.include?grade.month}
      
      if @subjects.first == 'select_all'
        subjects = MonthlyGrade.uniq_grade grades
        @total_no_show = total_no_show grades
        @subject_average = subject_average(grades)
      else
        @total_no_show = total_no_show(@subjects, grades)
        @subject_average = subject_average(@subjects, grades)
        grades = grades.select{|grade| @subjects.include?(grade.subject_name)}
        all_student_grades = all_student_grades.select{|grade| @subjects.include?(grade.subject_name)} 
      end
      
      @overall_average = calculate_overall_average grades
      
      @month_average = Grade.initialize_month_graph(Student.all_months_average(grades))
      
      @all_student_month_average = Grade.initialize_month_graph(Student.all_months_average(all_student_grades))
      @month_average = merge_graph(@month_average,@all_student_month_average)
      
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_student_grades), @student)
    end  
  end
  
  def change_student
    @student = StudentFromExcel.find_by_id(params[:student_list])
    
    @grades = params[:year].blank? ? @student.monthly_grades : @student.monthly_grades.where(month: params[:start]..params[:end]).where(year: params[:year])
    
    @total_no_show = total_no_show @grades
    @subject_average = subject_average(@grades)
    @overall_average = calculate_overall_average @grades
    
    @month_average = Grade.initialize_month_graph(Student.all_months_average(@grades))
    
    range = (params[:start].to_i..params[:end].to_i).to_a unless params[:year].blank?
    
    all_student_grades = params[:year].blank? ? (Grade.find_all_student_grade @student) : (Grade.find_all_student_grade @student).select{|grade| range.include?grade.month}
    
    @all_student_month_average = Grade.initialize_month_graph(Student.all_months_average(all_student_grades))
    
    @month_average = merge_graph(@month_average, @all_student_month_average)
    
    @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_student_grades), @student)
  end
  
  def change_date
    @student = StudentFromExcel.find_by_id(params[:student_id])
    @grades = @student.monthly_grades.where(month: params[:date][:start]..params[:date][:end]).where(year: params[:date][:year])
    
    @total_no_show = total_no_show @grades
    @subject_average = subject_average(@grades)
    @overall_average = calculate_overall_average @grades
    @month_average = Grade.initialize_month_graph(Student.all_months_average(@grades))
    range = (params[:date][:start].to_i..params[:date][:end].to_i).to_a
    all_student_grades = (Grade.find_all_student_grade @student).select{|grade| range.include?grade.month}
    
    @all_student_month_average = Grade.initialize_month_graph(Student.all_months_average(all_student_grades))
    
    @month_average = merge_graph(@month_average, @all_student_month_average)
    
    @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_student_grades), @student)
  end
  
  def new_registration_with_cpf
    @role = params[:role]
  end
  
  def signup
  end
  
  private
  
  def subject_average(subjects = false, grades)
    subjects = MonthlyGrade.uniq_grade grades unless subjects
    subject_average = {}
    subjects.each do |subject|
      perticular_subject = MonthlyGrade.particular_subject(grades, subject)
      grade = perticular_subject.reject{ |subject| subject.grade.blank? }
      subject_average.merge!({subject => ((grade.map(&:grade).inject(:+))/grade.count).round(2)}) unless grade.blank?
    end
    subject_average.sort_by {|k,v| v}.reverse
  end
  
  def total_no_show(subjects = false, grades)
    subjects = MonthlyGrade.uniq_grade grades unless subjects
    total_no_show = {}
    subjects.each do |subject|
      perticular_subject = MonthlyGrade.particular_subject(grades, subject)
      no_show = perticular_subject.reject{ |subject| subject.no_show.blank? }
      total_no_show.merge!({subject => no_show.map(&:no_show).inject(:+)}) unless no_show.blank?
    end
    total_no_show.sort_by {|k,v| v}.reverse
  end
  
  def calculate_overall_average grades
    average = 0
    grades.each{|grade| average = average + grade.grade unless grade.grade.blank?}
    average = (average/grades.reject{|grade| grade.grade.blank?}.size).round(2)  if average > 0
    average
  end
  
  def merge_graph(month_average, all_student_month_average)
    month_average[0].insert(2,"Class Average")
    for i in 1..month_average.length-1
      month_average[i].insert(2,all_student_month_average[i][1])
    end
    month_average
  end
  
end
