class ProfessorRecord < ActiveRecord::Base
  attr_accessible :email, :name, :school_grades_attributes
  has_many :professor_schools
  has_many :schools, :through => :professor_schools
  has_many :school_grades, :through => :professor_schools
  has_one :professor
  attr_accessible :school_grades_attributes
  accepts_nested_attributes_for :school_grades
  
  before_save :update_params
  
  private
  
  def update_params
    debugger
    puts "Test"
    
  end
  
end
