class MonthlyGrade < ActiveRecord::Base
  attr_accessible :grade, :record_date, :student_from_excel_id, :subject_name, :month, :no_show, :year
  validates :grade, numericality: true, inclusion: 0..10, allow_nil: true
  validates :no_show, numericality: true, inclusion: 0..31, allow_nil: true
  
  belongs_to :student_from_excel
  
  def self.uniq_grade grades
    grades.map(&:subject_name).uniq
  end

  def self.uniq_subjects grades
    grades.map(&:subject_name).uniq
  end
  
  def self.particular_subject(grades, subject) 
    grades.select{|grade| grade.subject_name==subject}
  end
  
end



