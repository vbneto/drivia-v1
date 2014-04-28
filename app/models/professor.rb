class Professor < ActiveRecord::Base
  belongs_to :user
  belongs_to :professor_record
  attr_accessible :birth_day, :gender, :grade_from_excel_id, :user_id
  
end
