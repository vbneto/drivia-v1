class MonthlyGradesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_professor!
  
  def update_grade
    student = StudentFromExcel.find(params[:grade][:student_from_excel_id])
    student_grade = student.student_grade(params[:grade][:subject_name], params[:grade][:bimester])
    student_status = student.get_active_status
    if student_grade.blank?
      student_grade = MonthlyGrade.new(params[:grade])
      student_grade.grade = params[:monthly_grade][:grade]
      student_grade.save
    else
      student_grade.update_attributes(:grade=>params[:monthly_grade][:grade])
    end
    respond_to do |format|
      format.json { respond_with_bip(student_grade) }
    end
  end
  
  def update_no_show
    student = StudentFromExcel.find(params[:grade][:student_from_excel_id])
    student_grade = student.student_grade(params[:grade][:subject_name], params[:grade][:bimester])
    student_status = student.get_active_status
    if student_grade.blank?
      student_grade = MonthlyGrade.new(params[:grade])
      student_grade.grade = params[:monthly_grade][:no_show]
      student_grade.save
    else
      student_grade.update_attributes(:no_show=>params[:monthly_grade][:no_show])
    end
    
    respond_to do |format|
      format.json { respond_with_bip(student_grade) }
    end
  end
  
  def import_student_grade
    school = current_professor.professor_record.schools.find(params["school_id"])
    MonthlyGrade.import_grade_list(school, params)
    flash[:notice] = "List of students imported."
    redirect_to professors_path
  end
  
end
