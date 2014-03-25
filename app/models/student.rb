class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  belongs_to :student_from_excel
  has_many :grades
  attr_accessible :birth_day, :cpf, :current_grade, :gender, :user_id, :school_id, :student_from_excel_id
  
  def self.find_student_by_student_id user_id
    self.find_by_user_id(User.find_by_id(user_id)).student_from_excel
  end
  
  def self.all_months_average(all_months, grades)
    month_average = {}
    all_months.each do |month|
      perticular_month = grades.select{|grade| grade.month == month}
      month_average.merge!({Date::MONTHNAMES[month] => ((perticular_month.map(&:grade).inject(:+))/perticular_month.count).round(2)})
    end
    month_average
  end
  
end
