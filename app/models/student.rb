class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  belongs_to :student_from_excel
  has_many :grades
  attr_accessible :birth_day, :cpf, :current_grade, :gender, :user_id, :school_id, :student_from_excel_id
  
  def self.find_student_by_student_id user_id
    self.find_by_user_id(User.find_by_id(user_id)).student_from_excel
  end
  
  def self.all_months_average(grades)
    all_months = grades.map(&:month).uniq
    month_average = {}
    all_months.each do |month|
      perticular_month = grades.select{|grade| grade.month == month}
      grade = perticular_month.reject{ |grade| grade.grade.blank? }.map(&:grade)
      month_average.merge!({Date::MONTHNAMES[month] => (grade.inject(:+)/perticular_month.count).round(2)}) unless grade.blank?
    end
    month_average
  end
  
  def self.all_students_average grades
    all_students = grades.map(&:student_from_excel_id).uniq
    students_average = {}
    all_students.each do |student|
      student_name = StudentFromExcel.find(student).student_name
      perticular_student_grade = grades.select{|grade| grade.student_from_excel_id == student}
      grade = perticular_student_grade.reject{ |grade| grade.grade.blank? }.map(&:grade)
      students_average.merge!({student_name => (grade.inject(:+)/grade.size).round(2)}) unless grade.blank?
    end
    students_average
  end    
  
end
