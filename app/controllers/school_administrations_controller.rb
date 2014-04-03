class SchoolAdministrationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_school_administration!
  
  def show_students
    @students = current_school_administration.student_from_excels.order('student_name asc')
  end
  
  def search_student
    @students = current_school_administration.find_students(params[:student_name])
    render 'show_students'
  end
  
  def show_parent
    @parent = User.find(params[:parent_id])
  end
  
end
