class Grade < ActiveRecord::Base
  has_many :subjects
  attr_accessible :name
  
  def self.initialize_month_graph(student_grade,user)
    hash_of_grade = Student.all_bimesters_average(student_grade)
    if user.is_parent? or user.is_school_administration?
      student_name = student_grade.first.student_from_excel.student_name
      hash_of_grade.to_a.insert(0,["Bimester",student_name])
    elsif user.is_student?
      hash_of_grade.to_a.insert(0,["Bimester","You"])
    end  
  end
  
  def self.initialize_student_graph(hash_of_data, student,user, class_average)
    unless hash_of_data.blank?
      hash_of_data.each{|data| data.insert(0,nil)}
      hash_of_data.first[0] = '+'
      hash_of_data.last[0] = '-'
      hash_of_data.each{|data| data[1] = nil unless data[1]==student.id}
      hash_of_data.each do |data|
        data[3] = class_average
        if data[1] == student.id
          data[1] = data[2]
          data[2] = nil
        end
      end
    end  
  end
  
end
