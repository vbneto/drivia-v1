class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home]
  
  def home
  end
  
  def index
  end
  
  def import_students_list
    is_create = User.import(params[:file])
    if is_create
      redirect_to users_path, notice: "List of students imported."
    else
      redirect_to users_path, notice: "some of the student not contained CPF."
    end
  end
  
  def parent_student
    
  end
  
end
