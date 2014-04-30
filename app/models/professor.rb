class Professor < ActiveRecord::Base
  belongs_to :user
  belongs_to :professor_record
  attr_accessible :birth_day, :gender, :professor_record_id, :user_id
  
end
