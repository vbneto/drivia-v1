class SchoolAdministration < ActiveRecord::Base
  attr_accessible :school_id, :user_id
  belongs_to :user
  has_many :student_from_excels, :through => :school
  has_many :grade_from_excels, :through => :school
  belongs_to :school
  
  def find_students (student)
    if student.blank?
      self.student_from_excels.order("current_grade ASC, student_name ASC")
    else
      self.student_from_excels.where("student_name LIKE ?" , "%#{student}%").order("current_grade ASC, student_name ASC")
    end
  end
  
  def find_parents (parent)
    Parent.joins(:student_from_excels => :school_administration).includes(:user).where("users.name=?",'parent')
    # need to test this feature
    if parent.blank?
      parents.order("current_grade ASC, student_name ASC")
    else
      parents.where("student_name LIKE ?" , "%#{student}%").order("current_grade ASC, student_name ASC")
    end
  end

  def find_student (student_from_excel_id)
    self.student_from_excels.find(student_from_excel_id)
  end
  
  def self.grade_name
    current_school_administration.school.grade_from_excels.map(&:grade_name).uniq
  end
  
  def all_parents students
    parents = []
    students.each{|student| student.parents.each{|parent| parents.insert(0,parent)}}
    parents.uniq
  end
end
