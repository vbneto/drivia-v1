class ProfessorsController < ApplicationController
  
  def show_students
    @school = School.find(params[:school_id])
    @subject = params[:subject]
    @students = @school.student_from_excels.select{|student| student.current_grade == params[:grade]}
    @month = params[:month].present? ? params[:month] : Date::MONTHNAMES[Date.today.month]
  end  
  
  def show_student_graph
    all_student_id = StudentFromExcel.where("school_id=? and current_grade=? ", params[:school_id], params[:grade]).map(&:id)
    all_student_grades = MonthlyGrade.select{|grade| all_student_id.include?(grade.student_from_excel_id)}
    all_student_with_subject = all_student_grades.select{|grade| grade.subject_name == params[:subject]}
    all_months = all_student_grades.map(&:month).uniq
    @all_student_month_average = Student.all_months_average(all_months, all_student_with_subject).to_a.insert(0,["Months","Grade"]) 
  end
  
end
