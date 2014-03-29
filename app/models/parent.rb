class Parent < ActiveRecord::Base
  belongs_to :user
  has_many :student_parents
  has_many :student_from_excels, through: :student_parents
  attr_accessible :birth_day, :gender, :user_id
  
end
