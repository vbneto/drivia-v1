class SchoolAdministration < ActiveRecord::Base
  attr_accessible :school_id, :user_id
  has_one :user
  has_many :student_from_excels, :through => :school
  belongs_to :school
  
  def find_students (student)
    if student.blank?
      self.student_from_excels
    else
      self.student_from_excels.where("student_name LIKE ?" , "%#{student}%")
    end
  end

end
