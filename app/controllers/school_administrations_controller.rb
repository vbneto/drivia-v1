class SchoolAdministrationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_school_administration!
  
  def show_students
   @students = current_school_administration.student_from_excels.order("current_grade ASC, student_name ASC")
   if params[:student_from_excel_id]
     flash[:notice] = "Records updated"
    end
  end
  
  def search_student
    @students = current_school_administration.find_students(params[:student_name])
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
      redirect_to show_students_school_administrations_path(:student_from_excel_id => @student_record)
    else
      flash[:notice] = "Records not updated" 
      render 'edit_student_record'
    end
  end
end
