class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_cpf, :create_registration_with_cpf, :parent_or_student_signup]
  
  def home
  end
  
  def index
  end
  
  def create_registration_with_cpf
    cpf = params[:cpf]
    @student = StudentFromExcel.find_by_cpf(cpf.to_s)
    if @student.nil?
      redirect_to root_path, :notice => "student not found"
    else
      render parent_or_student_users_path,:notice => "Please enter more details"
    end  
  end
  
  def new_registration_with_cpf
    @role = params[:role]
  end
  
  def parent_or_student_signup
  end
  
end
