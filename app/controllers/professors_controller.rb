class ProfessorsController < ApplicationController
  
  def show_students
    school = School.find(params[:school_id])
    @students = school.student_from_excels.select{|student| student.current_grade == params[:grade]} 
  end
  
end
