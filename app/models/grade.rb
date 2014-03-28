class Grade < ActiveRecord::Base
  has_many :subjects
  attr_accessible :name
  
  def self.initialize_month_graph(hash_of_data)
    hash_of_data.to_a.insert(0,["Months","Student Grade"])
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
  
  def self.find_all_student_grade student
    all_student_id_of_current_grade = StudentFromExcel.find_all_student_id_of_current_grade student
    MonthlyGrade.select{|grade| all_student_id_of_current_grade.include?(grade.student_from_excel_id)}
  end
  
end
