class MonthlyGrade < ActiveRecord::Base
  attr_accessible :grade, :record_date, :student_from_excel_id, :subject_name, :month, :no_show
  #validates :grade, :numericality => true, :inclusion => 0..10
  
  def self.uniq_grade grades
    grades.map(&:subject_name).uniq
  end
  
  def self.particular_subject(grades, subject) 
    grades.where("subject_name=?",subject)
  end
  
end



