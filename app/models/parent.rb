class Parent < ActiveRecord::Base
  belongs_to :user
  has_many :student_parents
  has_many :student_from_excels, through: :student_parents
  attr_accessible :birth_day, :gender, :user_id
  
  def find_age
    now = Time.now.utc
    now.year - self.birth_day.year - (self.birth_day.to_time.change(:year => now.year) > now ? 1 : 0) unless self.birth_day.blank?
  end
  
end
