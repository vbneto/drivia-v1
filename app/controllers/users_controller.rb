class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_code, :create_registration_with_code, :signup]
  
  def home
  end
  
  def index
    if current_parent
      @parent_students = current_parent.student_from_excels
      @student = @parent_students.first
    end
    @student = current_student.student_from_excel if current_student
    
    @student = StudentFromExcel.find_by_id(params[:student_id]) if current_school_administration
    
    @student_school_status = current_school_administration ? (@student.status_for_school current_school_administration.school_id) : @student.get_active_status
    @student_school_status = @student.student_statuses.first if @student_school_status.blank?
    @school_average = @student_school_status.school.school_average
    
    @student_monthly_grades = current_user.student_monthly_grades(@student, @student_school_status)
    @subject_average = Student.subject_average @student_monthly_grades
    @total_no_show = Student.total_no_show @student_monthly_grades
    
    unless @student_monthly_grades.blank?
      bimester_average_of_student = Grade.initialize_month_graph(@student_monthly_grades, current_user)
      all_students_grades = @student.find_fellow_students_monthly_grade(@student_monthly_grades.first.year, @student_school_status)
      
      student_available_bimester = @student_monthly_grades.map(&:bimester)
      all_students_grades.select!{|grade| student_available_bimester.include?grade.bimester}
      
      all_student_bimester_average = Grade.initialize_month_graph(all_students_grades,current_user)
      
      @month_average = merge_graph(bimester_average_of_student,all_student_bimester_average)
      
      @student_overall_average = student_monthly_grade_overall_average @student_monthly_grades
      @class_overall_average = student_monthly_grade_overall_average all_students_grades
      
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_students_grades), @student, current_user,@class_overall_average)
    end  
  end
  
  def create_registration_with_code
    @role = params[:user]
    if (@role == User.find_student_role || @role == User.find_parent_role)
      @code = params[:code]
      @student = StudentFromExcel.find_by_code(@code)
      if @student.nil?
        flash[:error]= "student with given code was not found"
        redirect_to new_registration_with_code_users_path(role: @role) and return
      elsif @role == User.find_student_role && !@student.student.blank?
        flash[:error]= "student was already signup with this code #{@code}"
        redirect_to new_registration_with_code_users_path(role: @role) and return
      elsif @student.is_deactive_student?
        flash[:error]= "Sorry, this account has been deactivated, please contact to school administration." 
        redirect_to new_registration_with_code_users_path(role: @role) and return
      elsif @role == User.find_parent_role && @student.student_parents.size == 2
        flash[:error]= "There are already two parents signup with this code #{@code}"
        redirect_to new_registration_with_code_users_path(role: @role) and return
      end
    elsif @role == User.find_professor_role
      @code = params[:code]
      @professor = ProfessorRecord.find_by_code(@code)
      if @professor.nil?
        flash[:error]= "Professor with given code was not found"
        redirect_to new_registration_with_code_users_path(role: @role) and return
      elsif @professor.professor
        flash[:error]= "Professor with given code was already present"
        redirect_to new_registration_with_code_users_path(role: @role) and return
      end
    end
    render ask_question_users_path  
  end
  
  def change_subjects
    params[:subjects].delete('multiselect-all') unless params[:subjects].blank?
    unless params[:subjects].blank?
      @subjects = params[:subjects]
      @number_of_subject_selected = params[:subjects].size - 1
      @student = StudentFromExcel.find_by_id(params[:student_id_of_subject]) if current_parent || current_school_administration
      @student = Student.find_by_user_id(current_user.id).student_from_excel if current_student
      student_status_id = params[:student_status_id_of_subject]
      @student_school_status = student_status_id.blank? ? @student.student_statuses.first : StudentStatus.find(student_status_id)
      @school_average = @student_school_status.school.school_average
      
      year = params[:year]
      all_student_grades = nil
      if year.blank?
        @student_monthly_grades = current_user.student_monthly_grades(@student, @student_school_status)
        all_student_grades = @student.find_fellow_students_monthly_grade(@student_monthly_grades.first.year, @student_school_status)
        student_available_bimester = @student_monthly_grades.map(&:bimester)
        all_student_grades.select!{|grade| student_available_bimester.include?grade.bimester}
      else
        date_range = (params[:start_month][0].to_i..params[:end_month][0].to_i).to_a 
        @student_monthly_grades = @student_school_status.monthly_grades.where(year: year) 
        @student_monthly_grades.select!{|grade| date_range.include?grade.bimester[0].to_i}
          
        all_student_grades = @student.find_fellow_students_monthly_grade(year.to_i, @student_school_status).select{|grade| date_range.include?grade.bimester[0].to_i}
      end
      
      @total_no_show = Student.total_no_show(@subjects, @student_monthly_grades)
      @subject_average = Student.subject_average(@subjects, @student_monthly_grades)
      @student_monthly_grades = @student_monthly_grades.select{|grade| @subjects.include?(grade.subject_name)}
      all_student_grades = all_student_grades.select{|grade| @subjects.include?(grade.subject_name)} 
      
      @student_overall_average = student_monthly_grade_overall_average @student_monthly_grades
      @class_overall_average = student_monthly_grade_overall_average all_student_grades
      
      @month_average = Grade.initialize_month_graph(@student_monthly_grades,current_user)
      
      @all_student_month_average = Grade.initialize_month_graph(all_student_grades,current_user) if @student_monthly_grades
      @month_average = merge_graph(@month_average,@all_student_month_average)
      
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_student_grades), @student, current_user, @class_overall_average)
    end  
  end
  
  def change_student
    @student = StudentFromExcel.find(params[:student_list])
    all_student_grades = nil
    student_grades = nil
    year = params[:year]
    selected_subjects = params[:subject_selected]
    
    @student_school_status = @student.student_statuses.first
    @school_average = @student_school_status.school.school_average
    if year.blank? || (!@student.monthly_grades.map(&:year).include?year.to_i) || true
      @student_monthly_grades = current_user.student_monthly_grades(@student, @student_school_status)
      student_grades = current_user.student_monthly_grades(@student, @student_school_status)
      all_student_grades = @student.find_fellow_students_monthly_grade(student_grades.first.year, @student_school_status) unless student_grades.blank?
    else
      range = (params[:start_month][0].to_i..params[:end_month][0].to_i).to_a
      @student_monthly_grades = @student_school_status.monthly_grades.where(year: year)
      @student_monthly_grades.select!{|grade| range.include?grade.bimester[0].to_i}
      
      all_student_grades = (@student.find_fellow_students_monthly_grade(year.to_i, @student_school_status)).select{|grade| range.include?grade.bimester[0].to_i}
    end
    @total_no_show = Student.total_no_show student_grades
    @subject_average = Student.subject_average(student_grades)
    
    @matched_subjects = student_grades.map(&:subject_name) & selected_subjects.split(',') unless selected_subjects.blank?
    unless selected_subjects.blank? or @matched_subjects.blank?
      @subject_average.select!{|average| selected_subjects.split(',').include?average[0]}
      @total_no_show.select!{|no_show| selected_subjects.split(',').include?no_show[0]}
      student_grades.select!{|grade| selected_subjects.split(',').include?grade.subject_name }
      all_student_grades.select!{|grade| selected_subjects.split(',').include?grade.subject_name }
    end  
    
    unless student_grades.blank?
      @student_overall_average = student_monthly_grade_overall_average student_grades
      @class_overall_average = student_monthly_grade_overall_average all_student_grades
      
      @month_average = Grade.initialize_month_graph(student_grades,current_user)
      
      @all_student_month_average = Grade.initialize_month_graph(all_student_grades,current_user) if @student_monthly_grades
      
      @month_average = merge_graph(@month_average, @all_student_month_average)
      
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_student_grades), @student, current_user, @class_overall_average)
    end
  end
  
  def change_date
    start_bimester = params[:start_month]
    end_bimester = params[:end_month]
    student_status_id = params[:student_status_id]
    year = params[:date][:year]
    selected_subjects = params[:subject_selected]
    @student = StudentFromExcel.find(params[:student_id])
    
    @student_school_status = student_status_id.blank? ? @student.student_statuses.first : StudentStatus.find(student_status_id)
    @school_average = @student_school_status.school.school_average
    
    @student_monthly_grades = @student_school_status.monthly_grades.where(year: year)
    student_grades = @student_school_status.monthly_grades.where(year: year)
    
    range = (start_bimester[0].to_i..end_bimester[0].to_i).to_a
    student_grades.select!{|grade| range.include?grade.bimester[0].to_i}
    all_student_grades = (@student.find_fellow_students_monthly_grade(student_grades.first.year, @student_school_status)).select{|grade| range.include?grade.bimester[0].to_i}
    
    unless student_grades.blank?
      @total_no_show = Student.total_no_show student_grades
      @subject_average = Student.subject_average(student_grades)
      unless selected_subjects.blank?
        @subject_average.select!{|average| selected_subjects.split(',').include?average[0]} 
        @total_no_show.select!{|no_show| selected_subjects.split(',').include?no_show[0]}
        student_grades.select!{|grade| selected_subjects.split(',').include?grade.subject_name }
        all_student_grades.select!{|grade| selected_subjects.split(',').include?grade.subject_name } 
      end
      @student_overall_average = student_monthly_grade_overall_average student_grades
      @class_overall_average = student_monthly_grade_overall_average all_student_grades
      
      @month_average = Grade.initialize_month_graph(student_grades,current_user)
      @all_student_month_average = Grade.initialize_month_graph(all_student_grades,current_user) if @student_monthly_grades
      
      @month_average = merge_graph(@month_average, @all_student_month_average)
      
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_student_grades), @student, current_user, @class_overall_average)
    end  
  end
  
  def change_school
    @student_school_status = StudentStatus.find(params[:student_status_id])
    @school_average = @student_school_status.school.school_average
    @student = @student_school_status.student_from_excel
    @student_monthly_grades = @student_school_status.monthly_grades
    @subject_average = Student.subject_average @student_monthly_grades
    @total_no_show = Student.total_no_show @student_monthly_grades
    month_average_of_student = Grade.initialize_month_graph(@student_monthly_grades,current_user)
    
    unless @student_monthly_grades.blank?
      all_students_grades = @student.find_fellow_students_monthly_grade(@student_monthly_grades.first.year, @student_school_status)
      
      student_available_month = @student_monthly_grades.map(&:month)
      all_students_grades.select!{|grade| student_available_month.include?grade.month}
      
      all_student_month_average = Grade.initialize_month_graph(all_students_grades,current_user) if @student_monthly_grades
      
      @month_average = merge_graph(month_average_of_student,all_student_month_average)
      
      @student_overall_average = student_monthly_grade_overall_average @student_monthly_grades
      @class_overall_average = student_monthly_grade_overall_average all_students_grades
      
      @average_particular_student_of_current_grade = Grade.initialize_student_graph((Student.all_students_average all_students_grades), @student, current_user, @class_overall_average)
    end  
  end
  
  def new_registration_with_code
    @role = params[:role]
  end
  
  def signup
  end
  
  def send_email_to_student
    @user = current_user
    if @user.is_student?
      flash[:notice] = "email is sent"
      UserMailer.send_mail_to_user(@user).deliver
    else
      flash[:error] = "You are not student"
    end
    redirect_to users_path
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
      next month_average[0].insert(2,"Class") if index == 0
      month_average[index].insert(2,all_student_month_average[index][1])
    end
  end
  
end
