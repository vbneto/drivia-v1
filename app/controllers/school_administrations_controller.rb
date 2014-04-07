class SchoolAdministrationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_school_administration!
  
  def show_students
   @all_students = current_school_administration.student_from_excels.order("current_grade ASC, student_name ASC")
  end
  
  def search_student
    @all_students = current_school_administration.find_students(params[:student_name])
    render 'show_students'
  end
  
  def show_parent
    @parent = User.find(params[:parent_id])
  end
  
  def edit_student_record
    @student_record = current_school_administration.find_student(params[:student_from_excel_id].to_i) 
  end
  
  def update_student
    @student_record = StudentFromExcel.find( params[:id] )
    params[:student_from_excel][:user_attributes][:name] = params[:student_from_excel][:student_name] unless params[:student_from_excel][:user_attributes].nil?
    if @student_record.update_attributes(params["student_from_excel"])
      flash[:notice] = "Records updated"
      redirect_to show_students_school_administrations_path
    else
      flash[:error] = "Records not updated" 
      render 'edit_student_record'
    end
  end

  def change_student_status
    student = StudentFromExcel.find(params[:student_id])
    is_saved = false
    if student.is_active_student?
      student.status = User.student_deactive
      is_saved = student.save
    elsif student.is_deactive_student?
      student.status = User.student_active
      is_saved = student.save
      student.update_student_parent_fields  if is_saved
    end    
    if is_saved
      flash[:success] = "Status changed successfully."  
    else
      flash[:error] = "This student is already active in another school.You can not activate him untill he is deactivated in other schools."  
    end
    redirect_to show_students_school_administrations_path
  end
  
  def apply_filter
    students = current_school_administration.student_from_excels
    students.select!{|student| student.current_grade == params[:grade]} if params[:grade] != 'All'
    students.select!{|student| student.student.present?.to_s == params[:first_access] } if params[:first_access] != 'All'
    students.select!{|student| student.status == params[:active] } if params[:active] != 'All'
    @all_students = students
  end

end
