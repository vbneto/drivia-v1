module ProfessorsHelper
  
  def monthly_grade_hash student
    {"student_from_excel_id"=>student.id,"student_status_id" => student.get_active_status.id, "subject_name"=>@subject, "bimester"=>@bimester, "grade_name"=>@grade_name, "grade_class"=>@grade_class, "year"=> Date.today.year }
  end 
  
end
