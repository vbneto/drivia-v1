class Professor < ActiveRecord::Base
  belongs_to :user
  belongs_to  :professor_record
  attr_accessible :birth_day, :gender, :professor_record_id, :user_id
  
  def professor_grades
    ProfessorRecord.find_by_code(self.professor_record.code).school_grades.where(status: User.student_active)
  end
  
end
