class MonthlyGrade < ActiveRecord::Base
  attr_accessible :grade, :record_date, :student_from_excel_id, :subject_name, :month, :no_show, :year
  validates :grade, numericality: true, inclusion: 0..10, allow_nil: true
  validates :grade, numericality: true, inclusion: 0..10, allow_nil: true
  
  def self.uniq_grade grades
    grades.map(&:subject_name).uniq
  end
  
  def self.particular_subject(grades, subject) 
    grades.where("subject_name=?",subject)
  end
  
end



