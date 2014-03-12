class SchoolsController < ApplicationController
  
  def new
    @school = School.new 
  end
  
  def create
    @school = School.new(params[:school])
    @school.save ? flash[:notice]="school save" : flash[:partial]="please fill form correctly"
    redirect_to admins_path
  end
  
  def index
    @schools = School.all
  end
  
  def import_students_list
    is_create = StudentFromExcel.import(params[:file],params[:school_id])
    if is_create
      redirect_to admins_path, notice: "List of students imported."
    else
      redirect_to admins_path, notice: "some of the student not contained CPF."
    end
  end
  
end
