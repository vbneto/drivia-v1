class StudentParent < ActiveRecord::Base
  attr_accessible :parent_id, :student_id
  belongs_to :parent
  belongs_to :student_from_excel
  
end
