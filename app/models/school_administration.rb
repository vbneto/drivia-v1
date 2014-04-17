class SchoolAdministration < ActiveRecord::Base
  attr_accessible :school_id, :user_id
  belongs_to :user
  has_many :student_from_excels, :through => :school
  has_many :grade_from_excels, :through => :school
  belongs_to :school
  
  def find_student (student_from_excel_id)
    self.student_from_excels.find(student_from_excel_id)
  end
  
  def self.grade_name
    current_school_administration.school.grade_from_excels.map(&:grade_name).uniq
  end
  
  def all_students student = nil
    if student.blank?
      StudentFromExcel.includes(:student_statuses).where(student_statuses: { school_id: self.school_id, year: Date.today.year.to_s})#.order("current_grade ASC, student_name ASC")
    else
      self.student_from_excels.where("student_name LIKE ?" , "%#{student}%").order("current_grade ASC, student_name ASC")
    end  
  end
  
  def all_parents (parent= nil ,school)
    if parent.blank?
      Parent.joins(:student_from_excels => :school_administration).where(student_from_excels: { school_id: school }).uniq.includes(:user)
    else
      Parent.joins(:student_from_excels => :school_administration).where(student_from_excels: { school_id: school }).includes(:user).where("users.name LIKE ?", "%#{parent}%")
    end
  end
  
end
