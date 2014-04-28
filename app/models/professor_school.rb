class ProfessorSchool < ActiveRecord::Base
  attr_accessible :professor_record_id, :school_id
  belongs_to :school
  belongs_to :professor_record
  has_many :school_grades
end
