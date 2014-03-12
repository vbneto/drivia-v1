class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  belongs_to :student_from_excel
  has_many :grades
  attr_accessible :birth_day, :cpf, :current_grade, :gender, :user_id, :school_id, :student_from_excel_id
end
