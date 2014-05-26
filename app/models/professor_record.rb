class ProfessorRecord < ActiveRecord::Base
  attr_accessible :code, :name, :school_grades_attributes
  
  has_many :professor_schools
  has_many :schools, :through => :professor_schools
  has_many :school_grades, :through => :professor_schools
  has_one :professor

  accepts_nested_attributes_for :school_grades
end
