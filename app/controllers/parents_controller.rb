class ParentsController < ApplicationController

  def new_student
    @students = Parent.find_by_user_id(current_user.id).student_from_excels
  end
  
  def create_registration_with_cpf
    @cpf = params[:cpf]
    @student = StudentFromExcel.find_by_cpf(@cpf)
    parent = Parent.find_by_user_id(current_user.id)
    if @student.nil?
      redirect_to new_student_parents_path, :flash =>{ :error => "student with given cpf was not found"} and return
    elsif @student.student_parents.size > 0
      unless @student.student_parents.select{|student| student.parent_id == parent.id }.blank?
        redirect_to new_student_parents_path, :flash =>{ :error => "You were already added this student"} and return
      end  
    elsif @student.student_parents.size == 2    
      redirect_to new_student_parents_path, :flash =>{ :error => "There are already two parents signup with this cpf #{@cpf}"} and return
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
