class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :student_from_excel
  attr_accessible :birth_day, :cpf, :current_grade, :gender, :user_id, :school_id, :student_from_excel_id
 
  def self.all_bimesters_average(monthly_grades)
    all_bimesters = monthly_grades.map(&:bimester).uniq.sort unless monthly_grades.blank?
    bimester_average = {}
    unless all_bimesters.blank?
      all_bimesters.each do |bimester|
        grades_of_bimester = monthly_grades.select{|grade| grade.bimester == bimester}
        grades = grades_of_bimester.reject{ |grade| grade.grade.blank? }.map(&:grade)
        bimester_average.merge!({bimester => (grades.inject(:+)/grades.size).round(2)}) unless grades.blank?
      end
    end  
    bimester_average
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
  
  def self.subject_average(subjects = false, grades)
    subjects = MonthlyGrade.uniq_subjects grades unless subjects
    subject_average = {}
    unless subjects.blank?
      subjects.each do |subject|
        perticular_subject = MonthlyGrade.particular_subject(grades, subject)
        grade = perticular_subject.reject{ |subject| subject.grade.blank? }
        subject_average.merge!({subject => ((grade.map(&:grade).inject(:+))/grade.count).round(2)}) unless grade.blank?
      end
    end  
    subject_average.sort_by {|k,v| v}.reverse
  end
  
  def self.total_no_show(subjects = false, grades)
    subjects = MonthlyGrade.uniq_subjects grades unless subjects
    total_no_show = {}
    unless subjects.blank?
      subjects.each do |subject|
        perticular_subject = MonthlyGrade.particular_subject(grades, subject)
        no_show = perticular_subject.reject{ |subject| subject.no_show.blank? }
        total_no_show.merge!({subject => no_show.map(&:no_show).inject(:+)}) unless no_show.blank?
      end
    end  
    total_no_show.sort_by {|k,v| v}.reverse
  end
end
