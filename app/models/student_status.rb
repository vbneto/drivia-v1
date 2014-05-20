class StudentStatus < ActiveRecord::Base
  attr_accessible :school_id, :status, :student_from_excel_id, :current_grade, :year, :grade_class, :ra
  belongs_to :student_from_excel
  belongs_to :school
  has_many :monthly_grades
  validate :validate_status_activation
  
  def validate_status_activation
    unless self.student_from_excel.blank?
      if self.student_from_excel.student_statuses.map(&:status).include?User.student_active and self.status == User.student_active
        errors.add(:status, "status is already active in some school")
      end
    end  
  end
  
end
