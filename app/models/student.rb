class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :student_from_excel
  attr_accessible :birth_day, :cpf, :current_grade, :gender, :user_id, :school_id, :student_from_excel_id
  
  def self.all_months_average(grades)
    all_months = grades.map(&:month).uniq
    month_average = {}
    all_months.each do |month|
      grades_of_month = grades.select{|grade| grade.month == month}
      grade = grades_of_month.reject{ |grade| grade.grade.blank? }.map(&:grade)
      month_average.merge!({Date::MONTHNAMES[month] => (grade.inject(:+)/grade.size).round(2)}) unless grade.blank?
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
      students_average.merge!({student => (grade.inject(:+)/grade.size).round(2)}) unless grade.blank?
    end
    students_average.sort_by {|k,v| v}.reverse
  end
  
end
