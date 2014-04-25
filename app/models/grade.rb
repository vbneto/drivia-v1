class Grade < ActiveRecord::Base
  has_many :subjects
  attr_accessible :name
  
  def self.initialize_month_graph(student_grade,user)
    hash_of_grade = Student.all_bimesters_average(student_grade)
    if user.is_parent? or user.is_professor?
      student_name = student_grade.first.student_from_excel.student_name
      hash_of_grade.to_a.insert(0,["Bimester",student_name])
    elsif user.is_student?
      hash_of_grade.to_a.insert(0,["Bimester","You"])
    end  
  end
  
  def self.initialize_student_graph(hash_of_data, student)
    unless hash_of_data.blank?
      if hash_of_data.first[0] == student.id
        hash_of_data.first[0] = 'Top '+student.student_name
        hash_of_data.last[0] = 'Worst'
      elsif hash_of_data.last[0] == student.id
        hash_of_data.last[0] = 'Worst '+student.student_name
        hash_of_data.first[0] = 'Top'
      else
        hash_of_data.first[0] = 'Top'
        hash_of_data.last[0] = 'Worst'
        hash_of_data.each{|data| data[0]=student.student_name if data[0]==student.id }   
      end
      hash_of_data.each{|data| data[0]='' unless data[0].is_a?String}
    end  
    hash_of_data.to_a.insert(0,["Student","Student Grade"])
  end
  
end
