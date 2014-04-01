class SchoolAdministration < ActiveRecord::Base
  attr_accessible :school_id, :user_id
  has_one :user
  has_many :student_from_excels, :through => :school
  belongs_to :school
end
