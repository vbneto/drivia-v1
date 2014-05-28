class School < ActiveRecord::Base
  attr_accessible :name, :student_from_excels_attributes, :school_average
  
  has_many :students, :dependent => :destroy
  has_many :professor_schools, :dependent => :destroy
  has_many :professor_records, :through => :professor_schools
  has_many :school_grades, :through => :professor_schools
  has_many :student_statuses, :dependent => :destroy
  has_many :student_from_excels, :through => :student_statuses
  has_many :parents, :through => :student_from_excels
  has_many :grade_from_excels, :dependent => :destroy
  has_one :school_administration, :dependent => :destroy
  
  validates :name, :presence => {:error => 'cannot be blank'}
  accepts_nested_attributes_for :student_from_excels
  
  scope :schools, ->(school_id) { where(id: school_id) }
  
  def self.students(school_id)
    schools(school_id).first.student_from_excels
  end
  
  def self.professor_details(school_id)
    schools(school_id).first.professor_records
  end
  
  def select_student_of_current_grade(grade_name, grade_class)
    self.student_from_excels.includes(:student_statuses).where("status=? and current_grade=? and grade_class=?", User.student_active, grade_name, grade_class)
  end
  
end
