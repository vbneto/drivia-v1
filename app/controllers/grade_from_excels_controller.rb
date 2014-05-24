class GradeFromExcelsController < ApplicationController
  
  def ask_for_code
  end
  
  def merge_professor_account
    new_professor_grades = GradeFromExcel.where(:code => params[:code])
    unless new_professor_grades.blank?
      if new_professor_grades.first.professor
        redirect_to professors_path, :flash => { :error => "This professor is already signup with other email you can not add this account"} and return
      end
      old_professor = current_professor.grade_from_excel
      new_professor_grades.each do |grade|
        grade.code = old_professor.code
        grade.save
      end
      redirect_to professors_path, :notice => "Your account was successfully updated. You are now linked to #{new_professor_grades.first.school.name}"
    else
      redirect_to professors_path, :flash =>{ :error => "Professor with given code is not available please contact to school administration"}
    end  
  end
  
end
