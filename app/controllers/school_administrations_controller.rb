class SchoolAdministrationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_school_administration!
  
  def show_users
   @all_students = current_school_administration.all_students.page(params[:page]).per(3)

   @parents = current_school_administration.all_parents current_school_administration.school_id
   @professors = current_school_administration.grade_from_excels
  end
  
  def search_student
    @all_students = current_school_administration.all_students(params[:student_name]).page(params[:page]).per(3)
  end
  
  def search_parent
    @parents = current_school_administration.all_parents(params[:parent_name],current_school_administration.school_id)
  end
  
  def show_parent
    @parent = User.find(params[:id])
  end
  
  def show_student
    @student = StudentFromExcel.find(params[:id])
  end
  
  def edit_student_record
    @student_record = current_school_administration.find_student(params[:student_from_excel_id].to_i) 
  end
  
  def edit_parent_record
    @parent_record = User.find(params[:parent_id].to_i)
  end
  
  def update_parent
    @parent_record = User.find(params[:id].to_i)
    if @parent_record.update_attributes(params["user"])
      flash[:notice] = "Records updated"
      redirect_to show_parent_school_administration_path(@parent_record)
    else
      flash[:error] = "Records not updated" 
      render 'edit_parent_record'
    end
  end
  
  def update_student
    @student_record = StudentFromExcel.find( params[:id] )
    params[:student_from_excel][:user_attributes][:name] = params[:student_from_excel][:student_name] unless params[:student_from_excel][:user_attributes].nil?
    if @student_record.update_attributes(params["student_from_excel"])
      flash[:notice] = "Records updated"
      redirect_to show_users_school_administrations_path
    else
      flash[:error] = "Records not updated" 
      render 'edit_student_record'
    end
  end

  def change_student_status
    student = StudentFromExcel.find(params[:id])
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
      flash[:notice] = "Status changed successfully."  
    else
      flash[:error] = "This student is already active in another school.You can not activate him untill he is deactivated in other schools."
    end
    redirect_to show_users_school_administrations_path
  end
  
  def change_parent_status
    parent = Parent.find(params[:id])
    if parent.is_active_parent?
      parent.status = User.student_deactive
      is_saved =parent.save
    elsif parent.is_deactive_parent? 
      parent.status = User.student_active
      is_saved =parent.save
    end
    if is_saved
      flash[:notice] = "Status changed successfully."  
    else
      flash[:error] = "This student is already active in another school.You can not activate him untill he is deactivated in other schools."
    end
    redirect_to show_users_school_administrations_path  
  end
  
  def apply_filter_to_student
    students = current_school_administration.student_from_excels
    students.select!{|student| student.current_grade == params[:grade]} if params[:grade] != 'All'
    students.select!{|student| student.student.present?.to_s == params[:first_access] } if params[:first_access] != 'All'
    students.select!{|student| student.status == params[:active] } if params[:active] != 'All'
    @all_students = students
  end
  
  def apply_filter_to_parent
    parents = current_school_administration.all_parents current_school_administration.school_id
    parents.select!{|parent| parent.status == params[:active_parent] } if params[:active_parent] != 'All'
    parents.select!{|parent| parent.student_from_excels.count == params[:student_number].to_i } if params[:student_number] != 'All' 
    @parents = parents
  end
  
end
