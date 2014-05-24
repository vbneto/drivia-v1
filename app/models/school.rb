class School < ActiveRecord::Base
  attr_accessible :name, :student_from_excels_attributes, :school_average
  
  has_many :students
  has_many :grades
  has_many :professors
  has_many :student_statuses
  has_many :student_from_excels, :through => :student_statuses
  has_many :parents, :through => :student_from_excels
  has_many :grade_from_excels
  has_one :school_administration
  validates :name, :presence => {:error => 'cannot be blank'}
  accepts_nested_attributes_for :student_from_excels
  
  scope :schools, ->(school_id) { where(id: school_id) }
  
  def self.students(school_id)
    schools(school_id).first.student_from_excels
  end
  
  def self.professor_details(school_id)
    schools(school_id).first.grade_from_excels
  end
  
end
