class ProfessorsController < ApplicationController
  
  def show_students
    @school = School.find(params[:school_id])
    @subject = params[:subject]
    @students = @school.student_from_excels.select{|student| student.current_grade == params[:grade]}
    @month = params[:month].present? ? params[:month] : Date::MONTHNAMES[Date.today.month]
  end  

end
