class MonthlyGradesController < ApplicationController
 
  def update_grade
    student = StudentFromExcel.find(params[:student_id])
    student_grade = student.student_grade(params[:subject], params[:month])
    
    if student_grade.blank?
      student_grade = MonthlyGrade.create(:record_date => Date.today,
                :student_from_excel_id => params[:student_id],
                :subject_name=> params[:subject],
                :grade => params[:monthly_grade][:grade],
                :month => Date::MONTHNAMES.index(params[:month])
                )
    else
      student_grade.update_attributes(:grade=>params[:monthly_grade][:grade])
    end
    respond_to do |format|
      format.json { respond_with_bip(student_grade) }
    end
   
  end
  
end
