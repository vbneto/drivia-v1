class ProfessorsController < ApplicationController
  
  def show_students
    @school = School.find(params[:school_id])
    @subject = params[:subject]
    @students = @school.student_from_excels.select{|student| student.current_grade == params[:grade]}
    @month = params[:month].present? ? params[:month] : Date::MONTHNAMES[Date.today.month]
  end  
  
  def show_student_graph
    all_student_grade_with_subject = student_of_current_grade_and_subject params
    @all_student_month_average = Grade.initialize_month_graph(Student.all_months_average(all_student_grade_with_subject))
  end
  
  private
  
  def student_of_current_grade_and_subject current_grade
    all_student_id = StudentFromExcel.where("school_id=? and current_grade=? ", current_grade[:school_id], current_grade[:grade]).map(&:id)
    all_student_grades = MonthlyGrade.select{|grade| all_student_id.include?(grade.student_from_excel_id)}
    all_student_grades.select{|grade| grade.subject_name == params[:subject]}
  end
  
end
