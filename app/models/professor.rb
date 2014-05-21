class Professor < ActiveRecord::Base
  belongs_to :user
  belongs_to  :grade_from_excel
  attr_accessible :birth_day, :gender, :grade_from_excel_id, :user_id
  
  def professor_grades
    GradeFromExcel.where(:code => self.grade_from_excel.code)
  end
  
end
