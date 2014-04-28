class ProfessorRecord < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :professor_schools
  has_many :schools, :through => :professor_schools
  has_one :professor
end
