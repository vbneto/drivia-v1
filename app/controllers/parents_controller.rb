class ParentsController < ApplicationController

  def new_student
    @students = Parent.find_by_user_id(current_user.id).student_from_excels
  end
  
  def create_registration_with_cpf
    @cpf = User.check_cpf params[:cpf]
    @student = StudentFromExcel.find_by_cpf(@cpf)
    parent = Parent.find_by_user_id(current_user.id)
    if @student.nil?
      redirect_to new_registration_with_cpf_users_path, :notice => "student with given cpf was not found" and return
    elsif @student.student_parents.size > 0
      if @student.student_parents.select{|student| student.parent_id== parent.id }.size == 1
        redirect_to root_path, :notice => "You were already added this student"
        return
      end  
    elsif @student.student_parents.size == 2    
      redirect_to root_path, :notice => "There are already two parents signup with this cpf #{@cpf}"
      return
    end  
    render ask_question_parents_path
  end
  
  def add_student
    cpf = params[:cpf]
    student = StudentFromExcel.find_by_cpf(cpf.to_s)
    parent = Parent.find_by_user_id(current_user.id)
    parent.student_parents.create(student_from_excel_id: student.id)
    redirect_to users_path, :notice=> 'Student was added successfully'  
  end
  
end
