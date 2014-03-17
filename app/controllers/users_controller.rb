class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_cpf, :create_registration_with_cpf, :parent_or_student_signup]
  
  def home
  end
  
  def index
  end
  
  def create_registration_with_cpf
    @cpf = params[:cpf]
    @role = params[:user]
    @student = StudentFromExcel.find_by_cpf(@cpf.to_s)
    if @student.nil?
      redirect_to root_path, :notice => "student with given cpf was not found"
    else
      if @role == 'student' && !Student.find_by_student_from_excel_id(@student.id.to_s).nil?
        redirect_to root_path, :notice => "student was already signup with this cpf #{@cpf}"
        return 
      elsif @role == 'parent' && @student.student_parents.size == 2    
        redirect_to root_path, :notice => "There are already two parents signup with this cpf #{@cpf}"
        return
      end  
      render ask_question_users_path
    end  
  end
  
  def new_registration_with_cpf
    @role = params[:role]
  end
  
  def parent_or_student_signup
  end
  
end
