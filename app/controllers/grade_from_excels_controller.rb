class GradeFromExcelsController < ApplicationController
  before_filter :require_professor!, :authenticate_user!
  before_filter :valid_professor_record_by_code, only: :merge_professor_account
  
  def ask_for_code
  end
  
  def merge_professor_account
    (redirect_to professors_path, :flash => { :error => "This professor is already signup with other email you can not add this account"} and return) if @new_professor_grade.professor
    old_professor = current_professor.professor_record
    flash[:notice] = "Your account was successfully updated. You are now linked to #{@new_professor_grade.schools.first.name}"
    @new_professor_grade.update_professor_school(old_professor)
    redirect_to professors_path
  end
  
  private
  
  def valid_professor_record_by_code
    @new_professor_grade = ProfessorRecord.find_by_code(params[:code])
    redirect_to add_new_professor_account_path, :flash =>{ :error => "Professor with given code is not available please contact to school administration"} if @new_professor_grade.blank?
  end
  
end
