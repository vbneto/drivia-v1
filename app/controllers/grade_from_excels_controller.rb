class GradeFromExcelsController < ApplicationController
  
  def ask_for_code
  end
  
  def merge_professor_account
    new_professor_grade = ProfessorRecord.where(:code => params[:code])
    unless new_professor_grade.blank?
      if new_professor_grade.first.professor
        redirect_to professors_path, :flash => { :error => "This professor is already signup with other email you can not add this account"} and return
      end
      old_professor = current_professor.professor_record
      
      new_professor_grade.first.professor_schools.each do |grade|
        grade.professor_record_id = old_professor.id
        grade.save
      end
      new_professor_grade.destroy_all
      redirect_to add_new_professor_account_path, :notice => "Your account was successfully updated. You are now linked to #{new_professor_grades.first.school.name}"
    else
      redirect_to add_new_professor_account_path, :flash =>{ :error => "Professor with given code is not available please contact to school administration"}
    end  
  end
  
end
