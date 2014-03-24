class Parent < ActiveRecord::Base
  belongs_to :user
  has_many :student_parents
  has_many :student_from_excels, through: :student_parents
  attr_accessible :birth_day, :gender, :user_id
  
  def self.find_student_by_parent_id parent_id
    self.find_by_user_id(parent_id).student_from_excels
  end
end
